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
#ifndef XLS_MODULES_AES_AES_128_TEST_COMMON_H_
#define XLS_MODULES_AES_AES_128_TEST_COMMON_H_

// Utilities common to AES-128 testing.
// These will likely be expanded/modified once tests exist for other key sizes.

#include <string>
#include <vector>

#include "absl/status/statusor.h"
#include "xls/ir/value.h"

namespace xls::aes {

// The number of bits 'n' bytes in an AES-128 key and block.
constexpr int32_t kKeyBits = 128;
constexpr int32_t kKeyBytes = kKeyBits / std::numeric_limits<uint8_t>::digits;
constexpr int32_t kBlockBits = 128;
constexpr int32_t kBlockBytes =
    kBlockBits / std::numeric_limits<uint8_t>::digits;
constexpr int32_t kInitVectorBits = 96;
constexpr int32_t kInitVectorBytes =
    kInitVectorBits / std::numeric_limits<uint8_t>::digits;

using Block = std::array<uint8_t, kBlockBytes>;
using Key = std::array<uint8_t, kKeyBytes>;
using InitVector = std::array<uint8_t, kInitVectorBytes>;
using AuthData = std::vector<Block>;

// Returns a string representation of the given key in a format suitable for
// printing/debugging.
std::string FormatKey(const std::array<uint8_t, kKeyBytes>& key);

// Returns a string representation of the given block in a format suitable for
// printing/debugging.
std::string FormatBlock(const Block& block);
std::string FormatBlocks(const std::vector<Block>& block, int indent);

// Returns a string representation of the initialization vector for AES counter
// modes.
std::string FormatInitVector(const InitVector& iv);

// Prints an appropriate error message on a block value mismatch.
void PrintFailure(const Block& expected_block, const Block& actual_block,
                  int32_t index, bool ciphertext);

// Converts the given key (vector of 16 bytes) into an XLS value.
absl::StatusOr<Value> KeyToValue(const Key& key);

Value InitVectorToValue(const InitVector& iv);

// Converts the given block into an XLS value.
absl::StatusOr<Value> BlockToValue(const Block& block);

// Converts the given value into a block.
absl::StatusOr<Block> ValueToBlock(const Value& value);

// Populates the given buffer with the value of "key". In DSLX land, a key is
// four sequential u32s, but XLS is big-endian, so we need to re-lay out our
// bits appropriately.
void KeyToBuffer(const Key& key, std::array<uint32_t, 4>* buffer);

}  // namespace xls::aes

#endif  // XLS_MODULES_AES_AES_128_TEST_COMMON_H_
