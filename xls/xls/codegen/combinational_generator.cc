// Copyright 2020 The XLS Authors
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

#include "xls/codegen/combinational_generator.h"

#include "absl/memory/memory.h"
#include "absl/status/status.h"
#include "absl/status/statusor.h"
#include "absl/strings/str_cat.h"
#include "absl/strings/str_format.h"
#include "absl/strings/str_join.h"
#include "absl/strings/str_split.h"
#include "xls/codegen/block_conversion.h"
#include "xls/codegen/block_generator.h"
#include "xls/codegen/codegen_options.h"
#include "xls/codegen/codegen_pass.h"
#include "xls/codegen/codegen_pass_pipeline.h"
#include "xls/codegen/flattening.h"
#include "xls/codegen/module_builder.h"
#include "xls/codegen/module_signature.h"
#include "xls/codegen/node_expressions.h"
#include "xls/codegen/signature_generator.h"
#include "xls/codegen/vast.h"
#include "xls/common/logging/log_lines.h"
#include "xls/common/logging/logging.h"
#include "xls/common/status/ret_check.h"
#include "xls/common/status/status_macros.h"
#include "xls/ir/bits.h"
#include "xls/ir/dfs_visitor.h"
#include "xls/ir/function.h"
#include "xls/ir/node.h"
#include "xls/ir/node_iterator.h"
#include "xls/ir/node_util.h"
#include "xls/ir/nodes.h"
#include "xls/ir/type.h"

namespace xls {
namespace verilog {
namespace {

// Returns the functions invoked by the given function via Invoke instructions.
std::vector<FunctionBase*> InvokedFunctions(FunctionBase* f) {
  absl::flat_hash_set<FunctionBase*> invoked_set;
  std::vector<FunctionBase*> invoked;
  for (Node* node : f->nodes()) {
    if (node->Is<Invoke>()) {
      FunctionBase* to_apply = node->As<Invoke>()->to_apply();
      auto [_, inserted] = invoked_set.insert(to_apply);
      if (inserted) {
        invoked.push_back(to_apply);
      }
    }
  }
  return invoked;
}

// Recursive DFS visitor of the call graph induced by invoke
// instructions. Builds a post order of functions in the post_order vector.
void DfsVisit(FunctionBase* f, absl::flat_hash_set<FunctionBase*>* visited,
              std::vector<FunctionBase*>* post_order) {
  visited->insert(f);
  for (FunctionBase* invoked : InvokedFunctions(f)) {
    if (!visited->contains(invoked)) {
      DfsVisit(invoked, visited, post_order);
    }
  }
  post_order->push_back(f);
}

// Returns the functions and procs in package 'p' in a DFS post order traversal
// of the call graph induced by invoke nodes.
std::vector<FunctionBase*> FunctionsInPostOrder(Package* p, FunctionBase* root) {
  absl::flat_hash_set<FunctionBase*> visited;
  std::vector<FunctionBase*> post_order;
  DfsVisit(root, &visited, &post_order);
  return post_order;
}

} // namespace


absl::StatusOr<ModuleGeneratorResult> GenerateCombinationalModule(
    FunctionBase* module, const CodegenOptions& options) {
  VerilogLineMap verilog_line_map;
  std::string verilog;
  ModuleSignature signature;

  for (FunctionBase* f : FunctionsInPostOrder(module->package(), module)) {
    Block* block = nullptr;

    XLS_RET_CHECK(f->IsProc() || f->IsFunction());
    if (f->IsFunction()) {
      XLS_ASSIGN_OR_RETURN(block, FunctionToCombinationalBlock(
                                                               dynamic_cast<Function*>(f), options));
      block->spfe_private = dynamic_cast<Function*>(f)->spfe_private;
    } else {
      XLS_ASSIGN_OR_RETURN(
                           block, ProcToCombinationalBlock(dynamic_cast<Proc*>(f), options));
    }

    CodegenPassUnit unit(f->package(), block);

    CodegenPassOptions codegen_pass_options;
    codegen_pass_options.codegen_options = options;

    PassResults results;
    XLS_RETURN_IF_ERROR(CreateCodegenPassPipeline()
                        ->Run(&unit, codegen_pass_options, &results)
                        .status());
    XLS_RET_CHECK(unit.signature.has_value());
    XLS_ASSIGN_OR_RETURN(verilog,
                         GenerateVerilog(block, options, &verilog_line_map));
    signature = unit.signature.value();
  }

  return ModuleGeneratorResult{verilog, verilog_line_map,
                               signature};
}

}  // namespace verilog
}  // namespace xls
