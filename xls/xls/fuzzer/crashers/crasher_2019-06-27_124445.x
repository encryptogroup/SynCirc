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

// options: {"input_is_dslx": true, "ir_converter_args": ["--top=main"], "convert_to_ir": true, "optimize_ir": true, "codegen": true, "codegen_args": ["--generator=pipeline", "--pipeline_stages=3"], "simulate": false, "simulator": null}
// args: bits[22]:0x389849; bits[4]:0xe
// args: bits[22]:0x4cc3a; bits[4]:0x2
// args: bits[22]:0x1ac760; bits[4]:0x2
// args: bits[22]:0x3fd199; bits[4]:0x8
// args: bits[22]:0x2606fa; bits[4]:0x7
// args: bits[22]:0x1885a7; bits[4]:0xb
// args: bits[22]:0x331972; bits[4]:0x3
// args: bits[22]:0x378afb; bits[4]:0xb
// args: bits[22]:0x400; bits[4]:0x9
// args: bits[22]:0x2927b1; bits[4]:0x0
// args: bits[22]:0x200000; bits[4]:0x1
// args: bits[22]:0x213cad; bits[4]:0x4
// args: bits[22]:0x1020e2; bits[4]:0x9
// args: bits[22]:0x6471b; bits[4]:0xc
// args: bits[22]:0x10d906; bits[4]:0xd
// args: bits[22]:0x3f77d6; bits[4]:0xe
// args: bits[22]:0x1676b8; bits[4]:0xb
// args: bits[22]:0x2a78df; bits[4]:0x7
// args: bits[22]:0x1713cb; bits[4]:0x7
// args: bits[22]:0x1859fa; bits[4]:0x1
// args: bits[22]:0x360cec; bits[4]:0x4
// args: bits[22]:0x30dbc8; bits[4]:0xa
// args: bits[22]:0x39733f; bits[4]:0x4
// args: bits[22]:0x1bfa53; bits[4]:0xf
// args: bits[22]:0x1a5aaf; bits[4]:0xa
// args: bits[22]:0x6fe2b; bits[4]:0xc
// args: bits[22]:0x10cc7f; bits[4]:0xd
// args: bits[22]:0x2b35d0; bits[4]:0xd
// args: bits[22]:0x32a88e; bits[4]:0x8
// args: bits[22]:0x19329b; bits[4]:0x3
// args: bits[22]:0xc952a; bits[4]:0x7
// args: bits[22]:0x200000; bits[4]:0xa
// args: bits[22]:0x3b4b84; bits[4]:0xa
// args: bits[22]:0x253fcd; bits[4]:0x0
// args: bits[22]:0x2db2af; bits[4]:0xd
// args: bits[22]:0x35226d; bits[4]:0x1
// args: bits[22]:0x3afbfd; bits[4]:0x4
// args: bits[22]:0xd85ba; bits[4]:0x4
// args: bits[22]:0x3cb472; bits[4]:0x6
// args: bits[22]:0x1c6050; bits[4]:0x7
// args: bits[22]:0x38c98c; bits[4]:0xc
// args: bits[22]:0x37e97e; bits[4]:0x3
// args: bits[22]:0x3ebd1b; bits[4]:0x5
// args: bits[22]:0x6f17c; bits[4]:0xb
// args: bits[22]:0x12fe7a; bits[4]:0x6
// args: bits[22]:0x158f79; bits[4]:0x5
// args: bits[22]:0x16d2bf; bits[4]:0x1
// args: bits[22]:0x318a26; bits[4]:0xf
// args: bits[22]:0x4; bits[4]:0x9
// args: bits[22]:0xd52e; bits[4]:0x8
// args: bits[22]:0x255524; bits[4]:0x9
// args: bits[22]:0x2b2fb2; bits[4]:0x8
// args: bits[22]:0x2ae1e4; bits[4]:0x5
// args: bits[22]:0x36304a; bits[4]:0x5
// args: bits[22]:0x196396; bits[4]:0xc
// args: bits[22]:0x2dad63; bits[4]:0x1
// args: bits[22]:0x3f1a3e; bits[4]:0x6
// args: bits[22]:0x1f0beb; bits[4]:0x5
// args: bits[22]:0xa7e6e; bits[4]:0x8
// args: bits[22]:0xa242c; bits[4]:0x7
// args: bits[22]:0x9a275; bits[4]:0xa
// args: bits[22]:0x2d2741; bits[4]:0x5
// args: bits[22]:0x1b9751; bits[4]:0x6
// args: bits[22]:0x0; bits[4]:0x2
// args: bits[22]:0x2cfd73; bits[4]:0xb
// args: bits[22]:0x400; bits[4]:0x8
// args: bits[22]:0x64882; bits[4]:0x8
// args: bits[22]:0x2; bits[4]:0x7
// args: bits[22]:0x393a49; bits[4]:0xb
// args: bits[22]:0x3c1ca2; bits[4]:0xf
// args: bits[22]:0xabf2c; bits[4]:0xa
// args: bits[22]:0x280d7a; bits[4]:0xa
// args: bits[22]:0xf9c14; bits[4]:0x0
// args: bits[22]:0x1eaa2a; bits[4]:0x0
// args: bits[22]:0xdd5c; bits[4]:0x1
// args: bits[22]:0x4000; bits[4]:0xf
// args: bits[22]:0x3ce9de; bits[4]:0x3
// args: bits[22]:0x2fb2a9; bits[4]:0x1
// args: bits[22]:0x3fffff; bits[4]:0xa
// args: bits[22]:0xe95d8; bits[4]:0xb
// args: bits[22]:0xc1421; bits[4]:0x1
// args: bits[22]:0xf060e; bits[4]:0x4
// args: bits[22]:0x343093; bits[4]:0xe
// args: bits[22]:0x11a48d; bits[4]:0xe
// args: bits[22]:0x1c497c; bits[4]:0x7
// args: bits[22]:0x103d; bits[4]:0x3
// args: bits[22]:0x80; bits[4]:0x0
// args: bits[22]:0x174292; bits[4]:0x8
// args: bits[22]:0x100e31; bits[4]:0x1
// args: bits[22]:0x3ad65f; bits[4]:0x0
// args: bits[22]:0x2a1b4c; bits[4]:0x5
// args: bits[22]:0x201195; bits[4]:0x0
// args: bits[22]:0x2276cc; bits[4]:0x0
// args: bits[22]:0x1be09b; bits[4]:0x8
// args: bits[22]:0x151e32; bits[4]:0xe
// args: bits[22]:0x2db0b7; bits[4]:0x3
// args: bits[22]:0xc2826; bits[4]:0x4
// args: bits[22]:0x1466e8; bits[4]:0x6
// args: bits[22]:0x6d0ed; bits[4]:0x3
// args: bits[22]:0x29e15; bits[4]:0x2
// args: bits[22]:0x21928f; bits[4]:0x7
// args: bits[22]:0x2000; bits[4]:0x9
// args: bits[22]:0xf3a7f; bits[4]:0x1
// args: bits[22]:0x2f84b6; bits[4]:0xf
// args: bits[22]:0x3f2eea; bits[4]:0x2
// args: bits[22]:0x2aaaaa; bits[4]:0x8
// args: bits[22]:0x1dd398; bits[4]:0xf
// args: bits[22]:0x155555; bits[4]:0x5
// args: bits[22]:0xacf85; bits[4]:0x1
// args: bits[22]:0x26ca0d; bits[4]:0xa
// args: bits[22]:0x3f88e; bits[4]:0xb
// args: bits[22]:0x41e4f; bits[4]:0xf
// args: bits[22]:0x34889e; bits[4]:0x7
// args: bits[22]:0x39d30a; bits[4]:0x5
// args: bits[22]:0x22cffa; bits[4]:0x1
// args: bits[22]:0x8; bits[4]:0xd
// args: bits[22]:0x189cf7; bits[4]:0x2
// args: bits[22]:0x2dc0ef; bits[4]:0x1
// args: bits[22]:0x34b1e8; bits[4]:0x7
// args: bits[22]:0x85d44; bits[4]:0x2
// args: bits[22]:0x18c7ee; bits[4]:0x6
// args: bits[22]:0x17ce84; bits[4]:0x7
// args: bits[22]:0x92356; bits[4]:0xf
// args: bits[22]:0x281a4f; bits[4]:0x1
// args: bits[22]:0x40000; bits[4]:0x9
// args: bits[22]:0x30ca20; bits[4]:0xd
// args: bits[22]:0x15b6a5; bits[4]:0xc
// args: bits[22]:0x7b3df; bits[4]:0xd
// args: bits[22]:0x1e1cc3; bits[4]:0xe
// args: bits[22]:0x10000; bits[4]:0xa
// args: bits[22]:0x34ca3f; bits[4]:0x7
// args: bits[22]:0x16399d; bits[4]:0x5
// args: bits[22]:0x3d3a6d; bits[4]:0x4
// args: bits[22]:0x4ddcb; bits[4]:0xb
// args: bits[22]:0x2e054b; bits[4]:0x0
// args: bits[22]:0x391cf5; bits[4]:0xd
// args: bits[22]:0x3ca1b5; bits[4]:0x1
// args: bits[22]:0x326d6e; bits[4]:0xd
// args: bits[22]:0x930ce; bits[4]:0x3
// args: bits[22]:0x3ead0; bits[4]:0x0
// args: bits[22]:0xbab69; bits[4]:0x7
// args: bits[22]:0x400; bits[4]:0xe
// args: bits[22]:0x31a243; bits[4]:0x1
// args: bits[22]:0x696c1; bits[4]:0x2
// args: bits[22]:0x10; bits[4]:0x8
// args: bits[22]:0x3be8e5; bits[4]:0x6
// args: bits[22]:0x1e92bb; bits[4]:0x1
// args: bits[22]:0x26fe8; bits[4]:0x1
// args: bits[22]:0x23a250; bits[4]:0x8
// args: bits[22]:0x636ba; bits[4]:0xe
// args: bits[22]:0x15a44f; bits[4]:0x8
// args: bits[22]:0x69ded; bits[4]:0x4
// args: bits[22]:0xc4b92; bits[4]:0xa
// args: bits[22]:0xf6efb; bits[4]:0xe
// args: bits[22]:0x3baa1e; bits[4]:0xc
// args: bits[22]:0x1b0f18; bits[4]:0xe
// args: bits[22]:0x30f84b; bits[4]:0x9
// args: bits[22]:0x3d1754; bits[4]:0x0
// args: bits[22]:0x1030d2; bits[4]:0xe
// args: bits[22]:0x12609d; bits[4]:0x3
// args: bits[22]:0x37b445; bits[4]:0xf
// args: bits[22]:0x1da1d; bits[4]:0x6
// args: bits[22]:0x3629f2; bits[4]:0xc
// args: bits[22]:0x1c2224; bits[4]:0x4
// args: bits[22]:0x3486f9; bits[4]:0xa
// args: bits[22]:0x216279; bits[4]:0x1
// args: bits[22]:0x1000; bits[4]:0xa
// args: bits[22]:0x3fffff; bits[4]:0x8
// args: bits[22]:0x1b87c1; bits[4]:0xd
// args: bits[22]:0x1f126e; bits[4]:0x0
// args: bits[22]:0xbc745; bits[4]:0x6
// args: bits[22]:0x4000; bits[4]:0x2
// args: bits[22]:0x400; bits[4]:0xd
// args: bits[22]:0x1c4579; bits[4]:0x2
// args: bits[22]:0x3b8652; bits[4]:0xe
// args: bits[22]:0x4e4f6; bits[4]:0x8
// args: bits[22]:0x3244b3; bits[4]:0xe
// args: bits[22]:0xcde0a; bits[4]:0xe
// args: bits[22]:0x314f1f; bits[4]:0xd
// args: bits[22]:0x3c57ad; bits[4]:0x9
// args: bits[22]:0x1eac23; bits[4]:0xc
// args: bits[22]:0x1f897f; bits[4]:0x4
// args: bits[22]:0x366dda; bits[4]:0xc
// args: bits[22]:0x3a603f; bits[4]:0xe
// args: bits[22]:0x103049; bits[4]:0x4
// args: bits[22]:0x200000; bits[4]:0x6
// args: bits[22]:0x357b21; bits[4]:0x9
// args: bits[22]:0x2696a; bits[4]:0xa
// args: bits[22]:0x123db5; bits[4]:0x1
// args: bits[22]:0x37a6d6; bits[4]:0xb
// args: bits[22]:0x1b0891; bits[4]:0xa
// args: bits[22]:0x36d17b; bits[4]:0xd
// args: bits[22]:0x11eab1; bits[4]:0x4
// args: bits[22]:0x9843d; bits[4]:0x4
// args: bits[22]:0x2ea281; bits[4]:0xc
// args: bits[22]:0x886ba; bits[4]:0xd
// args: bits[22]:0x333c60; bits[4]:0xe
// args: bits[22]:0x20cd53; bits[4]:0xd
// args: bits[22]:0x2e9574; bits[4]:0x4
// args: bits[22]:0x123dff; bits[4]:0xa
// args: bits[22]:0xece70; bits[4]:0x9
// args: bits[22]:0x1aff50; bits[4]:0xd
// args: bits[22]:0x2ba1c1; bits[4]:0xe
// args: bits[22]:0x1977f1; bits[4]:0xd
// args: bits[22]:0x396ba3; bits[4]:0x0
// args: bits[22]:0x312622; bits[4]:0x6
// args: bits[22]:0x100c22; bits[4]:0xe
// args: bits[22]:0x3f9836; bits[4]:0x7
// args: bits[22]:0x21eaba; bits[4]:0x0
// args: bits[22]:0x30160e; bits[4]:0x4
// args: bits[22]:0x24e078; bits[4]:0x5
// args: bits[22]:0x225c23; bits[4]:0xa
// args: bits[22]:0x54e1f; bits[4]:0x4
// args: bits[22]:0x18721b; bits[4]:0x7
// args: bits[22]:0x9e9d7; bits[4]:0x1
// args: bits[22]:0x7697f; bits[4]:0x3
// args: bits[22]:0x3d9a0c; bits[4]:0x5
// args: bits[22]:0x31b3b5; bits[4]:0xd
// args: bits[22]:0x3be18d; bits[4]:0xf
// args: bits[22]:0x26d49a; bits[4]:0xf
// args: bits[22]:0x37c9a1; bits[4]:0x7
// args: bits[22]:0x40; bits[4]:0x1
// args: bits[22]:0x1a4fa5; bits[4]:0x5
// args: bits[22]:0x10; bits[4]:0xf
// args: bits[22]:0x4000; bits[4]:0x7
// args: bits[22]:0x3b0c39; bits[4]:0x3
// args: bits[22]:0x155555; bits[4]:0xd
// args: bits[22]:0x4000; bits[4]:0x3
// args: bits[22]:0x3ed902; bits[4]:0x1
// args: bits[22]:0x39ede2; bits[4]:0x7
// args: bits[22]:0x16d05a; bits[4]:0xb
// args: bits[22]:0x14e187; bits[4]:0xe
// args: bits[22]:0x113261; bits[4]:0xa
// args: bits[22]:0x1105f4; bits[4]:0xb
// args: bits[22]:0x2c0a30; bits[4]:0xf
// args: bits[22]:0x19dd88; bits[4]:0x2
// args: bits[22]:0x158a91; bits[4]:0x0
// args: bits[22]:0xc24da; bits[4]:0xc
// args: bits[22]:0x3f091f; bits[4]:0xc
// args: bits[22]:0x2ed183; bits[4]:0x8
// args: bits[22]:0x36bccf; bits[4]:0x3
// args: bits[22]:0x1135e3; bits[4]:0x3
// args: bits[22]:0x2a8dee; bits[4]:0x4
// args: bits[22]:0x392d92; bits[4]:0x4
// args: bits[22]:0x1bcf88; bits[4]:0x4
// args: bits[22]:0x4000; bits[4]:0xb
// args: bits[22]:0x4a587; bits[4]:0x7
// args: bits[22]:0x3a8b47; bits[4]:0x5
// args: bits[22]:0x4; bits[4]:0xe
// args: bits[22]:0xed6d4; bits[4]:0x3
// args: bits[22]:0x30d631; bits[4]:0x8
// args: bits[22]:0x273465; bits[4]:0xb
// args: bits[22]:0x3ad03a; bits[4]:0x6
// args: bits[22]:0x307149; bits[4]:0x1
// args: bits[22]:0x28798a; bits[4]:0x2
// args: bits[22]:0x11d1a; bits[4]:0x2
// args: bits[22]:0x1f484; bits[4]:0xd
// args: bits[22]:0x2f7ef1; bits[4]:0x4
// args: bits[22]:0x33b1f2; bits[4]:0xc
// args: bits[22]:0x332615; bits[4]:0x5
// args: bits[22]:0xbbef6; bits[4]:0x3
// args: bits[22]:0x156d0c; bits[4]:0x2
// args: bits[22]:0x38e644; bits[4]:0x3
// args: bits[22]:0x118057; bits[4]:0xa
// args: bits[22]:0x1f99da; bits[4]:0xd
// args: bits[22]:0x2f4df; bits[4]:0xa
// args: bits[22]:0x20c7f4; bits[4]:0x8
// args: bits[22]:0x86eea; bits[4]:0x4
// args: bits[22]:0x206ffd; bits[4]:0xb
// args: bits[22]:0x238cdb; bits[4]:0x1
// args: bits[22]:0x34c0da; bits[4]:0xa
// args: bits[22]:0x4000; bits[4]:0x2
// args: bits[22]:0x10cd9; bits[4]:0x8
// args: bits[22]:0x15ca51; bits[4]:0x3
// args: bits[22]:0xbc916; bits[4]:0x3
// args: bits[22]:0x3816ef; bits[4]:0xe
// args: bits[22]:0x36826c; bits[4]:0xb
// args: bits[22]:0x295159; bits[4]:0x1
// args: bits[22]:0x3aaea8; bits[4]:0x1
// args: bits[22]:0x1ebd6b; bits[4]:0xd
// args: bits[22]:0x31b3d6; bits[4]:0x8
// args: bits[22]:0x3f21e0; bits[4]:0x0
// args: bits[22]:0x400; bits[4]:0x6
// args: bits[22]:0x2cfcee; bits[4]:0x1
// args: bits[22]:0x74d09; bits[4]:0xc
// args: bits[22]:0xafec6; bits[4]:0xd
// args: bits[22]:0xe54ad; bits[4]:0x3
// args: bits[22]:0x91017; bits[4]:0xe
// args: bits[22]:0x72cb6; bits[4]:0x6
// args: bits[22]:0xd0195; bits[4]:0x5
// args: bits[22]:0x2d0e43; bits[4]:0x2
// args: bits[22]:0x10000; bits[4]:0xb
// args: bits[22]:0x21ae4b; bits[4]:0xc
// args: bits[22]:0x280413; bits[4]:0x9
// args: bits[22]:0x20; bits[4]:0x8
// args: bits[22]:0x208f65; bits[4]:0x4
// args: bits[22]:0x30db87; bits[4]:0x1
// args: bits[22]:0x31eeb9; bits[4]:0x8
// args: bits[22]:0x1fa08d; bits[4]:0xa
// args: bits[22]:0x31ecb3; bits[4]:0xf
// args: bits[22]:0x3287a6; bits[4]:0xa
// args: bits[22]:0x14b3d4; bits[4]:0xd
// args: bits[22]:0x87b33; bits[4]:0x1
// args: bits[22]:0x2e6ca4; bits[4]:0x7
// args: bits[22]:0x3992af; bits[4]:0xf
// args: bits[22]:0x44f03; bits[4]:0x9
// args: bits[22]:0x1c3db5; bits[4]:0x0
// args: bits[22]:0x1da22d; bits[4]:0x6
// args: bits[22]:0x102a60; bits[4]:0xf
// args: bits[22]:0x8; bits[4]:0x5
// args: bits[22]:0x1ea45e; bits[4]:0x9
// args: bits[22]:0x3d970b; bits[4]:0x5
// args: bits[22]:0xefbef; bits[4]:0x9
// args: bits[22]:0x1e62f8; bits[4]:0x2
// args: bits[22]:0x3e6715; bits[4]:0xb
// args: bits[22]:0xd9f41; bits[4]:0x7
// args: bits[22]:0x19d933; bits[4]:0x5
// args: bits[22]:0x34f3a3; bits[4]:0xf
// args: bits[22]:0x26b2b1; bits[4]:0x5
// args: bits[22]:0x20; bits[4]:0x3
// args: bits[22]:0x22e05e; bits[4]:0x9
// args: bits[22]:0x25a217; bits[4]:0x8
// args: bits[22]:0x47b5d; bits[4]:0xa
// args: bits[22]:0x2; bits[4]:0x2
// args: bits[22]:0x1972d9; bits[4]:0x6
// args: bits[22]:0x3e8b12; bits[4]:0x3
// args: bits[22]:0x2c68c1; bits[4]:0xa
// args: bits[22]:0x8d0b0; bits[4]:0x6
// args: bits[22]:0x2015ab; bits[4]:0x9
// args: bits[22]:0x19e2c7; bits[4]:0xb
// args: bits[22]:0x31f170; bits[4]:0x6
// args: bits[22]:0x5de6f; bits[4]:0x5
// args: bits[22]:0x335d95; bits[4]:0x8
// args: bits[22]:0x3fffff; bits[4]:0xe
// args: bits[22]:0x80000; bits[4]:0xf
// args: bits[22]:0x41e50; bits[4]:0x3
// args: bits[22]:0x17a970; bits[4]:0x9
// args: bits[22]:0x2d1307; bits[4]:0x2
// args: bits[22]:0xc76ea; bits[4]:0xe
// args: bits[22]:0x42bdb; bits[4]:0xf
// args: bits[22]:0x163d5f; bits[4]:0x9
// args: bits[22]:0x268bdc; bits[4]:0x2
// args: bits[22]:0x38a479; bits[4]:0x0
// args: bits[22]:0xbaf13; bits[4]:0x8
// args: bits[22]:0x25ca29; bits[4]:0x0
// args: bits[22]:0x1cf6ff; bits[4]:0xd
// args: bits[22]:0x10; bits[4]:0x2
// args: bits[22]:0x1a5443; bits[4]:0x0
// args: bits[22]:0x42b56; bits[4]:0xa
// args: bits[22]:0x15c12c; bits[4]:0xd
// args: bits[22]:0x3151f1; bits[4]:0x4
// args: bits[22]:0x265543; bits[4]:0xd
// args: bits[22]:0x2e265c; bits[4]:0xf
// args: bits[22]:0x3e6e1d; bits[4]:0x0
// args: bits[22]:0x376937; bits[4]:0xb
// args: bits[22]:0x8; bits[4]:0xd
// args: bits[22]:0x382292; bits[4]:0x2
// args: bits[22]:0x3c249d; bits[4]:0xf
// args: bits[22]:0x9549d; bits[4]:0x8
// args: bits[22]:0x3d083f; bits[4]:0x1
// args: bits[22]:0x253f54; bits[4]:0xe
// args: bits[22]:0x241cb9; bits[4]:0xd
// args: bits[22]:0x24f20c; bits[4]:0x2
// args: bits[22]:0x374c9a; bits[4]:0x4
// args: bits[22]:0x1ef780; bits[4]:0x3
// args: bits[22]:0x1d5ded; bits[4]:0x5
// args: bits[22]:0x21f61; bits[4]:0x4
// args: bits[22]:0xf520b; bits[4]:0x9
// args: bits[22]:0x36a9c4; bits[4]:0x3
// args: bits[22]:0xab752; bits[4]:0xb
// args: bits[22]:0x2e104e; bits[4]:0x3
// args: bits[22]:0x17b8de; bits[4]:0x5
// args: bits[22]:0x35cd0b; bits[4]:0x9
// args: bits[22]:0x33ff12; bits[4]:0x6
// args: bits[22]:0x20; bits[4]:0x5
// args: bits[22]:0x3eabc8; bits[4]:0xf
// args: bits[22]:0x2faf08; bits[4]:0x2
// args: bits[22]:0x3007e0; bits[4]:0xd
// args: bits[22]:0x2b8576; bits[4]:0xf
// args: bits[22]:0x10; bits[4]:0x9
// args: bits[22]:0x8; bits[4]:0x1
// args: bits[22]:0x4ac5e; bits[4]:0x3
// args: bits[22]:0x2f0369; bits[4]:0xe
// args: bits[22]:0x3d3b14; bits[4]:0x5
// args: bits[22]:0x26c2b7; bits[4]:0xa
// args: bits[22]:0x4; bits[4]:0x3
// args: bits[22]:0x3ae4db; bits[4]:0x2
// args: bits[22]:0x21b2ce; bits[4]:0x5
// args: bits[22]:0x31391e; bits[4]:0x0
// args: bits[22]:0x251b11; bits[4]:0xf
// args: bits[22]:0x357f43; bits[4]:0xc
// args: bits[22]:0x80; bits[4]:0x9
// args: bits[22]:0x3fffff; bits[4]:0xe
// args: bits[22]:0x26ab78; bits[4]:0x1
// args: bits[22]:0x5bf55; bits[4]:0x9
// args: bits[22]:0xbe7a8; bits[4]:0xd
// args: bits[22]:0x20501d; bits[4]:0x9
// args: bits[22]:0x1f0c92; bits[4]:0xa
// args: bits[22]:0x58baa; bits[4]:0xf
// args: bits[22]:0x102d4d; bits[4]:0x1
// args: bits[22]:0x365fd7; bits[4]:0x3
// args: bits[22]:0x4d70f; bits[4]:0x0
// args: bits[22]:0x1c00be; bits[4]:0x6
// args: bits[22]:0x37f574; bits[4]:0x5
// args: bits[22]:0x1eaa0b; bits[4]:0x3
// args: bits[22]:0x234c74; bits[4]:0x2
// args: bits[22]:0x20e195; bits[4]:0x4
// args: bits[22]:0x2c6977; bits[4]:0x1
// args: bits[22]:0x2743d1; bits[4]:0xd
// args: bits[22]:0x1cf9ba; bits[4]:0xd
// args: bits[22]:0x1f27fb; bits[4]:0xa
// args: bits[22]:0x3d52ee; bits[4]:0xd
// args: bits[22]:0x2aaaaa; bits[4]:0x9
// args: bits[22]:0x148c7c; bits[4]:0xf
// args: bits[22]:0x1c7538; bits[4]:0x6
// args: bits[22]:0x1ac7bd; bits[4]:0x7
// args: bits[22]:0x2ab5a1; bits[4]:0xe
// args: bits[22]:0xc42e9; bits[4]:0x1
// args: bits[22]:0x3c3d36; bits[4]:0x6
// args: bits[22]:0x1f72cf; bits[4]:0xa
// args: bits[22]:0x3dd7ce; bits[4]:0x7
// args: bits[22]:0x12ba65; bits[4]:0xa
// args: bits[22]:0x764c1; bits[4]:0xc
// args: bits[22]:0x394126; bits[4]:0x4
// args: bits[22]:0x25fd14; bits[4]:0xd
// args: bits[22]:0x2000; bits[4]:0x1
// args: bits[22]:0x2afec9; bits[4]:0xf
// args: bits[22]:0x1f646f; bits[4]:0xa
// args: bits[22]:0x351421; bits[4]:0x8
// args: bits[22]:0x1c6a8f; bits[4]:0xf
// args: bits[22]:0x2e7259; bits[4]:0x4
// args: bits[22]:0x1b603; bits[4]:0x5
// args: bits[22]:0x22d35f; bits[4]:0x1
// args: bits[22]:0x23c811; bits[4]:0x9
// args: bits[22]:0x3719fc; bits[4]:0xb
// args: bits[22]:0x400; bits[4]:0x4
// args: bits[22]:0x2e0954; bits[4]:0x6
// args: bits[22]:0x2ef3d6; bits[4]:0x1
// args: bits[22]:0x200; bits[4]:0xc
// args: bits[22]:0x417d4; bits[4]:0xb
// args: bits[22]:0x36154; bits[4]:0x3
// args: bits[22]:0x3ee5c9; bits[4]:0x6
// args: bits[22]:0x40; bits[4]:0x4
// args: bits[22]:0x24a526; bits[4]:0xa
// args: bits[22]:0xe4540; bits[4]:0xa
// args: bits[22]:0x2bab43; bits[4]:0x0
// args: bits[22]:0x64075; bits[4]:0x9
// args: bits[22]:0x64fc0; bits[4]:0x1
// args: bits[22]:0x2770db; bits[4]:0xb
// args: bits[22]:0x3ec78c; bits[4]:0xc
// args: bits[22]:0x263395; bits[4]:0xd
// args: bits[22]:0x361948; bits[4]:0x0
// args: bits[22]:0x209070; bits[4]:0x5
// args: bits[22]:0x8eb4d; bits[4]:0x9
// args: bits[22]:0x1e02b; bits[4]:0x0
// args: bits[22]:0x1d5f0f; bits[4]:0x9
// args: bits[22]:0x533fd; bits[4]:0xc
// args: bits[22]:0x35d0eb; bits[4]:0x1
// args: bits[22]:0x1e434b; bits[4]:0x3
// args: bits[22]:0x143a66; bits[4]:0x7
// args: bits[22]:0x28f25e; bits[4]:0xb
// args: bits[22]:0x1a0721; bits[4]:0xd
// args: bits[22]:0x46c98; bits[4]:0x9
// args: bits[22]:0x200e6; bits[4]:0x8
// args: bits[22]:0x2416a4; bits[4]:0xa
// args: bits[22]:0x2a5615; bits[4]:0x4
// args: bits[22]:0x203010; bits[4]:0xd
// args: bits[22]:0x2bce22; bits[4]:0xf
// args: bits[22]:0x303c9c; bits[4]:0x8
// args: bits[22]:0x1fd4aa; bits[4]:0xb
// args: bits[22]:0x191281; bits[4]:0x1
// args: bits[22]:0x16593c; bits[4]:0x2
// args: bits[22]:0x203dd4; bits[4]:0x5
// args: bits[22]:0x361899; bits[4]:0xa
// args: bits[22]:0x5f465; bits[4]:0x1
// args: bits[22]:0x40; bits[4]:0x3
// args: bits[22]:0x2aaaaa; bits[4]:0xe
// args: bits[22]:0x2b1ff; bits[4]:0xf
// args: bits[22]:0x23c632; bits[4]:0xb
// args: bits[22]:0x1f1cee; bits[4]:0x5
// args: bits[22]:0x4a592; bits[4]:0x7
// args: bits[22]:0x2b6a96; bits[4]:0x8
// args: bits[22]:0x2f5ced; bits[4]:0x6
// args: bits[22]:0xe1762; bits[4]:0xd
// args: bits[22]:0x23fb00; bits[4]:0x7
// args: bits[22]:0x24f07a; bits[4]:0x0
// args: bits[22]:0x3ca2e6; bits[4]:0xe
// args: bits[22]:0x3748fd; bits[4]:0x2
// args: bits[22]:0x27b81a; bits[4]:0x9
// args: bits[22]:0x68b88; bits[4]:0x3
// args: bits[22]:0x37cb11; bits[4]:0xa
// args: bits[22]:0x2c4421; bits[4]:0x3
// args: bits[22]:0x2d9e9; bits[4]:0x2
// args: bits[22]:0x188064; bits[4]:0x3
// args: bits[22]:0x3bcfd5; bits[4]:0xb
// args: bits[22]:0x2fbf11; bits[4]:0x5
// args: bits[22]:0x2eda0b; bits[4]:0x8
// args: bits[22]:0xfcdd3; bits[4]:0x5
// args: bits[22]:0x2367a9; bits[4]:0x5
// args: bits[22]:0x3e66a2; bits[4]:0x9
// args: bits[22]:0x1e8a10; bits[4]:0x6
// args: bits[22]:0x10b23b; bits[4]:0x4
// args: bits[22]:0x33050e; bits[4]:0xa
// args: bits[22]:0x188e38; bits[4]:0x7
// args: bits[22]:0x713d4; bits[4]:0xf
// args: bits[22]:0x24bed; bits[4]:0x1
// args: bits[22]:0x30c670; bits[4]:0x7
// args: bits[22]:0x2b772d; bits[4]:0xc
// args: bits[22]:0xc703c; bits[4]:0xe
// args: bits[22]:0x7f65; bits[4]:0xd
// args: bits[22]:0x102e10; bits[4]:0x1
// args: bits[22]:0x1a7aca; bits[4]:0xc
fn main(x1348850: u22, x1348851: u4) -> (u20, u20, u4, u4, u20) {
    let x1348852: u4 = (u4:0x1);
    let x1348853: u20 = (u20:0x40);
    let x1348854: u4 = !(x1348852);
    let x1348855: u22 = (x1348850) | ((x1348853 as u22));
    let x1348856: u22 = !(x1348850);
    let x1348857: u20 = (x1348853) + ((x1348856 as u20));
    let x1348858: u20 = (x1348857) - ((x1348854 as u20));
    let x1348859: u20 = (((x1348855 as s20)) >> (x1348853)) as u20;
    (x1348858, x1348858, x1348852, x1348851, x1348857)
}


