// Copyright 2022 The XLS Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef XLS_JIT_FUNCTION_JIT_H_
#define XLS_JIT_FUNCTION_JIT_H_

#include "absl/status/status.h"
#include "absl/status/statusor.h"
#include "absl/types/span.h"
#include "xls/common/status/status_macros.h"
#include "xls/ir/events.h"
#include "xls/ir/function.h"
#include "xls/ir/value.h"
#include "xls/ir/value_view.h"
#include "xls/jit/jit_runtime.h"
#include "xls/jit/llvm_type_converter.h"
#include "xls/jit/orc_jit.h"

namespace xls {

// This class provides a facility to execute XLS functions (on the host) by
// converting it to LLVM IR, compiling it, and finally executing it.
class FunctionJit {
 public:
  // Returns an object containing a host-compiled version of the specified XLS
  // function.
  static absl::StatusOr<std::unique_ptr<FunctionJit>> Create(
      Function* xls_function, int64_t opt_level = 3);

  // Returns the bytes of an object file containing the compiled XLS function.
  static absl::StatusOr<std::vector<char>> CreateObjectFile(
      Function* xls_function, int64_t opt_level = 3);

  // Executes the compiled function with the specified arguments.
  absl::StatusOr<InterpreterResult<Value>> Run(absl::Span<const Value> args);

  // As above, buth with arguments as key-value pairs.
  absl::StatusOr<InterpreterResult<Value>> Run(
      const absl::flat_hash_map<std::string, Value>& kwargs);

  // Executes the compiled function with the arguments and results specified as
  // "views" - flat buffers onto which structures layouts can be applied (see
  // value_view.h).
  //
  // Argument packing and unpacking into and out of LLVM-space can consume a
  // surprisingly large amount of execution time. Deferring such transformations
  // (and applying views) can eliminate this overhead and still give access tor
  // result data. Users needing less performance can still use the
  // Value-returning methods above for code simplicity.
  // Drops any events collected during evaluation (except assertion failures
  // which turn into errors).
  // TODO(https://github.com/google/xls/issues/506): 2021-10-13 Figure out
  // if we want a way to return events in the view and packed view interfaces
  // (or if their performance-focused execution means events are unimportant).
  absl::Status RunWithViews(absl::Span<uint8_t*> args,
                            absl::Span<uint8_t> result_buffer);

  // Similar to RunWithViews(), except the arguments here are _packed_views_ -
  // views whose data elements are tightly packed, with no padding bits or bytes
  // between them. The function return value is specified as the last arg - its
  // storage must ALSO be pre-allocated before this call.
  //
  // Example (for a binary float32 operation):
  // float RunFloat(float a_f, float b_f);
  //  using PF32 = PackedTupleView<PackedBitsView<23>, ..., PackedBitsView<1>>;
  //  PF32 a(&a_f);
  //  PF32 b(&b_f);
  //  float x_f;
  //  PF32 x(&x_f);
  //  jit->RunWithPackedViews(a, b, x);
  //  return x_f;
  //
  // For most users, the autogenerated DSLX headers should be used as the JIT -
  // and especially the packed-view-using-call - interface; there are some
  // sharp edges here!
  // TODO(rspringer): Add user data support here.
  template <typename... ArgsT>
  absl::Status RunWithPackedViews(ArgsT... args) {
    uint8_t* arg_buffers[sizeof...(ArgsT)];
    uint8_t* result_buffer;
    // Walk the type tree to get each arg's data buffer into our view/arg list.
    PackArgBuffers(arg_buffers, &result_buffer, args...);

    InterpreterEvents events;
    packed_invoker_(arg_buffers, result_buffer, &events,
                    /*user_data=*/nullptr, runtime());

    return InterpreterEventsToStatus(events);
  }

  // Returns the function that the JIT executes.
  FunctionBase* function() { return xls_function_; }

  // Gets the size of the compiled function's args or return type in bytes.
  // These values only correspond to view buffers, and not *PACKED* view
  // buffers.
  int64_t GetArgTypeSize(int arg_index) { return arg_type_bytes_[arg_index]; }
  int64_t GetReturnTypeSize() { return return_type_bytes_; }

  JitRuntime* runtime() { return ir_runtime_.get(); }

  LlvmTypeConverter* type_converter() { return &orc_jit_->GetTypeConverter(); }

  OrcJit& GetOrcJit() const { return *orc_jit_; }

 private:
  explicit FunctionJit(Function* xls_function);

  static absl::StatusOr<std::unique_ptr<FunctionJit>> CreateInternal(
      Function* xls_function, int64_t opt_level, bool emit_object_code);

  // Builds a function which wraps the natively compiled XLS function `callee`
  // (as built by xls::BuildFunction) with another function which accepts the
  // input arguments as an array of pointers to buffers and the output as a
  // pointer to a buffer. The input/output values are in the native LLVM data
  // layout. The function signature is:
  //
  //   void f(uint8_t*[] inputs, uint8_t* output,
  //          void* events, void* user_data, void* jit_runtime)
  //
  // `inputs` is an array containing a pointer for each input argument. The
  // pointer points to a buffer containing the respective argument in the native
  // LLVM data layout.
  //
  // `outputs` points to an empty buffer appropriately sized to accept the
  // result in the native LLVM data layout.
  absl::StatusOr<llvm::Function*> BuildWrapper(llvm::Function* callee);

  // As BuildWrapper but the inputs and outputs are taken/returned in a packed
  // representation.
  absl::StatusOr<llvm::Function*> BuildPackedWrapper(llvm::Function* callee);

  // Simple templates to walk down the arg tree and populate the corresponding
  // arg/buffer pointer.
  template <typename FrontT, typename... RestT>
  void PackArgBuffers(uint8_t** arg_buffers, uint8_t** result_buffer,
                      FrontT front, RestT... rest) {
    arg_buffers[0] = front.buffer();
    PackArgBuffers(&arg_buffers[1], result_buffer, rest...);
  }

  // Base case for the above recursive template.
  template <typename LastT>
  void PackArgBuffers(uint8_t** arg_buffers, uint8_t** result_buffer,
                      LastT front) {
    *result_buffer = front.buffer();
  }

  std::unique_ptr<OrcJit> orc_jit_;

  Function* xls_function_;

  // Size of the function's args or return type as flat bytes.
  std::vector<int64_t> arg_type_bytes_;
  int64_t return_type_bytes_;

  std::unique_ptr<JitRuntime> ir_runtime_;

  // When initialized, this points to the compiled output.
  using JitFunctionType = void (*)(const uint8_t* const* inputs,
                                   uint8_t* output, InterpreterEvents* events,
                                   void* user_data, JitRuntime* jit_runtime);
  JitFunctionType invoker_;

  // Packed types for above.
  using PackedJitFunctionType = void (*)(const uint8_t* const* inputs,
                                         uint8_t* output,
                                         InterpreterEvents* events,
                                         void* user_data,
                                         JitRuntime* jit_runtime);
  PackedJitFunctionType packed_invoker_;
};

// Builds and returns an LLVM IR function constructed from the given XLS
// function. The function accepts arguments by value in their native LLVM
// representation and returns the result in the same representation. The
// signature of the function is:
//
//   retT f(arg_0_T arg_0, ..., arg_n_T arg_n,
//          void* events, void* user_data, void* jit_runtime)
//
// Where:
//   retT        : native type of the return value
//   arg_i_T     : native type of the `i`-th argument
//   arg_i       : the `i`-th argument
//   events      : a pointer to an InterpreterEvents object
//   user_data   : unused
//   jit_runtime : a pointer to a JitRuntime
absl::StatusOr<llvm::Function*> BuildFunction(Function* xls_function,
                                              llvm::Module* module,
                                              OrcJit& jit);

// JIT-compiles the given xls_function and invokes it with args, returning the
// resulting return value. Note that this will cause the overhead of creating a
// FunctionJit object each time, so external caching strategies are generally
// preferred.
absl::StatusOr<InterpreterResult<Value>> CreateAndRun(
    Function* xls_function, absl::Span<const Value> args);

}  // namespace xls

#endif  // XLS_JIT_FUNCTION_JIT_H_
