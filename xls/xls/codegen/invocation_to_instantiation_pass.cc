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

#include "xls/codegen/invocation_to_instantiation_pass.h"

#include "absl/strings/str_format.h"
#include "xls/common/status/status_macros.h"
#include "xls/codegen/vast.h"
#include "xls/ir/node_util.h"

namespace xls::verilog {

absl::StatusOr<bool> InvocationToInstantiationPass::RunInternal(
    CodegenPassUnit* unit, const CodegenPassOptions& options,
    PassResults* results) const {
  bool changed = false;
  Block* block = unit->block;

  for (Node* node : block->nodes()) {
    if (node->Is<Invoke>()) {
      Invoke* invocation = node->As<Invoke>();
      FunctionBase* to_apply = invocation->to_apply();
      std::string function_name = to_apply->name();
      XLS_ASSIGN_OR_RETURN(Block* instantiated_block, unit->package->GetBlock(function_name));
      absl::Span<InputPort* const> block_input_ports = instantiated_block->GetInputPorts();
      absl::Span<OutputPort* const> block_output_ports = instantiated_block->GetOutputPorts();
      std::string block_instantiation_name = SanitizeIdentifier(invocation->GetName());

      XLS_ASSIGN_OR_RETURN(BlockInstantiation* block_instantiation, block->AddBlockInstantiation(block_instantiation_name, instantiated_block));

      XLS_RET_CHECK(block_input_ports.size() == invocation->operand_count());
      for (int64_t i = 0; i < invocation->operand_count(); ++i) {
        Node* operand = invocation->operand(i);
        const InputPort* input_port = block_input_ports[i];
        absl::string_view input_port_name = input_port->name();
        XLS_RETURN_IF_ERROR(block->MakeNode<InstantiationInput>(node->loc(), operand, block_instantiation, input_port_name).status());
      }

      XLS_RET_CHECK(block_output_ports.size() == 1);
      absl::string_view output_port_name = block_output_ports[0]->name();
      XLS_RETURN_IF_ERROR(node->ReplaceUsesWithNew<InstantiationOutput>(block_instantiation, output_port_name).status());

      // We don't need to remove the node as the DCE pass will take care of that
      changed = true;
    }
  }

  // std::cerr << unit->DumpIr() << std::endl;

  return changed;
}

}  // namespace xls::verilog
