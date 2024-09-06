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

// Test to compare the outputs of a reference vs. XLS AES implementation.
// Currently only supports AES-128 in CBC mode, but that may be expanded in the
// future.
//
// The code is unique_ptr heavy, but that'll change once templated over
// various key lengths.
#include <cstdint>
#include <vector>

#include "absl/flags/flag.h"
#include "absl/random/random.h"
#include "absl/status/status.h"
#include "absl/status/statusor.h"
#include "absl/strings/str_format.h"
#include "absl/strings/string_view.h"
#include "absl/time/time.h"
#include "openssl/aes.h"
#include "xls/common/init_xls.h"
#include "xls/common/logging/logging.h"
#include "xls/common/status/status_macros.h"
#include "xls/ir/value.h"
#include "xls/modules/aes/aes_128_decrypt_cc.h"
#include "xls/modules/aes/aes_128_encrypt_cc.h"
#include "xls/modules/aes/aes_test_common.h"

ABSL_FLAG(int32_t, num_samples, 1000,
          "The number of (randomly-generated) blocks to test.");

namespace xls::aes {

constexpr int kKeyBits = 128;
constexpr int kKeyBytes = kKeyBits / 8;
using Key = std::array<uint8_t, kKeyBytes>;

absl::StatusOr<Block> XlsEncrypt(const Key& key, const Block& plaintext) {
  // Not sure why Clang isn't able to infer the "16" correctly, but w/e.
  XLS_ASSIGN_OR_RETURN(Value key_value, KeyToValue<kKeyBytes>(key));
  XLS_ASSIGN_OR_RETURN(Value block_value, BlockToValue(plaintext));
  XLS_ASSIGN_OR_RETURN(Value result_value,
                       xls::aes::aes_encrypt(key_value, block_value));
  return ValueToBlock(result_value);
}

absl::StatusOr<Block> XlsDecrypt(const Key& key, const Block& ciphertext) {
  XLS_ASSIGN_OR_RETURN(Value key_value, KeyToValue<kKeyBytes>(key));
  XLS_ASSIGN_OR_RETURN(Value block_value, BlockToValue(ciphertext));
  XLS_ASSIGN_OR_RETURN(Value result_value,
                       xls::aes::aes_decrypt(key_value, block_value));
  return ValueToBlock(result_value);
}

Block ReferenceEncrypt(const Key& key, const Block& plaintext) {
  Block ciphertext;

  // Needed because the key is modified during operation.
  uint8_t local_key[kKeyBytes];
  memcpy(local_key, key.data(), kKeyBytes);

  // OpenSSL doesn't have a GCM implementation, so we'll have to use something
  // else once we get there.
  AES_KEY aes_key;
  XLS_QCHECK_EQ(AES_set_encrypt_key(local_key, kKeyBits, &aes_key), 0);
  AES_encrypt(plaintext.data(), ciphertext.data(), &aes_key);
  return ciphertext;
}

// Returns false on error (will terminate further runs).
absl::StatusOr<bool> RunSample(const Block& input, const Key& key,
                               absl::Duration* xls_encrypt_dur,
                               absl::Duration* xls_decrypt_dur) {
  XLS_VLOG(2) << "Plaintext: " << FormatBlock(input) << std::endl;

  Block reference_ciphertext = ReferenceEncrypt(key, input);

  absl::Time start_time = absl::Now();
  XLS_ASSIGN_OR_RETURN(Block xls_ciphertext, XlsEncrypt(key, input));
  *xls_encrypt_dur += absl::Now() - start_time;

  XLS_VLOG(2) << "Reference ciphertext: " << FormatBlock(reference_ciphertext)
              << std::endl;
  XLS_VLOG(2) << "XLS ciphertext: " << FormatBlock(xls_ciphertext) << std::endl;

  // Verify the ciphertexts match, to ensure we're actually doing the encryption
  // properly.
  for (int32_t i = 0; i < kBlockBytes; i++) {
    if (reference_ciphertext[i] != xls_ciphertext[i]) {
      PrintFailure(reference_ciphertext, xls_ciphertext, i,
                   /*ciphertext=*/true);
      return false;
    }
  }

  start_time = absl::Now();
  XLS_ASSIGN_OR_RETURN(Block xls_decrypted, XlsDecrypt(key, input));
  *xls_decrypt_dur += absl::Now() - start_time;

  XLS_VLOG(2) << "Decrypted plaintext: " << FormatBlock(xls_decrypted)
              << std::endl;

  // We can just compare the XLS result to the input to verify we're decrypting
  // right.
  for (int32_t i = 0; i < kBlockBytes; i++) {
    if (reference_ciphertext[i] != xls_ciphertext[i]) {
      PrintFailure(input, xls_decrypted, i, /*ciphertext=*/false);
      return false;
    }
  }

  return true;
}

absl::Status RealMain(int32_t num_samples) {
  Block input;
  Key key;
  absl::BitGen bitgen;
  absl::Duration xls_encrypt_dur;
  absl::Duration xls_decrypt_dur;
  for (int32_t i = 0; i < num_samples; i++) {
    for (int32_t j = 0; j < kKeyBytes; j++) {
      key[j] = absl::Uniform(bitgen, 0, 256);
    }
    for (int32_t j = 0; j < kBlockBytes; j++) {
      input[j] = absl::Uniform(bitgen, 0, 256);
    }

    XLS_ASSIGN_OR_RETURN(bool proceed, RunSample(input, key, &xls_encrypt_dur,
                                                 &xls_decrypt_dur));
    if (!proceed) {
      std::cout << "Plaintext: " << FormatBlock(input) << std::endl;
      std::cout << "Key: " << FormatKey<kKeyBytes>(key) << std::endl;
      break;
    }
  }

  std::cout << "Successfully ran " << num_samples << " samples." << std::endl;
  std::cout << "Avg. XLS encryption time: " << xls_encrypt_dur / num_samples
            << std::endl;
  std::cout << "Avg. XLS decryption time: " << xls_decrypt_dur / num_samples
            << std::endl;

  return absl::OkStatus();
}

}  // namespace xls::aes

int32_t main(int32_t argc, char** argv) {
  std::vector<absl::string_view> args = xls::InitXls(argv[0], argc, argv);
  XLS_QCHECK_OK(xls::aes::RealMain(absl::GetFlag(FLAGS_num_samples)));
  return 0;
}
