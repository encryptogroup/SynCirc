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
// args: bits[5]:0xf; bits[18]:0x150fd; bits[10]:0x28b; bits[30]:0x3cff79e0; bits[9]:0x1c4; bits[17]:0x116fc; bits[29]:0x762b910; bits[27]:0x63c9150; bits[30]:0x2148877a; bits[20]:0x2f476; bits[22]:0x54be6; bits[7]:0xf
// args: bits[5]:0xa; bits[18]:0x3d907; bits[10]:0x3fc; bits[30]:0x2aaaaaaa; bits[9]:0x53; bits[17]:0x1d962; bits[29]:0x1cbe5c98; bits[27]:0x4170a47; bits[30]:0x12475f3; bits[20]:0x1; bits[22]:0x309ceb; bits[7]:0xe
// args: bits[5]:0x13; bits[18]:0x27e70; bits[10]:0x3f; bits[30]:0x314b65ef; bits[9]:0x8; bits[17]:0x18dc4; bits[29]:0x2e3016; bits[27]:0x3fdad48; bits[30]:0x2a5e56c3; bits[20]:0x7cd7b; bits[22]:0x284be6; bits[7]:0x0
// args: bits[5]:0xe; bits[18]:0x78f4; bits[10]:0xdd; bits[30]:0x33168fde; bits[9]:0x83; bits[17]:0x142b6; bits[29]:0x1efd518e; bits[27]:0x1f1ba5f; bits[30]:0x96155a; bits[20]:0x4f9ae; bits[22]:0x3b2084; bits[7]:0x32
// args: bits[5]:0x14; bits[18]:0x1de4b; bits[10]:0xee; bits[30]:0x3bc2a89a; bits[9]:0x15a; bits[17]:0x1a19e; bits[29]:0x1000; bits[27]:0x45e3cd2; bits[30]:0x17e67792; bits[20]:0x4; bits[22]:0x1b3888; bits[7]:0x2
// args: bits[5]:0x4; bits[18]:0x38d77; bits[10]:0x1d5; bits[30]:0x7211008; bits[9]:0xe7; bits[17]:0xae38; bits[29]:0x962b6b5; bits[27]:0x7a93a41; bits[30]:0x3befe40b; bits[20]:0x5797e; bits[22]:0x362736; bits[7]:0x71
// args: bits[5]:0xf; bits[18]:0x30c5; bits[10]:0x33c; bits[30]:0x15a402cd; bits[9]:0x10; bits[17]:0x1d68d; bits[29]:0x15805af4; bits[27]:0x76c18e6; bits[30]:0x218587cc; bits[20]:0xe2535; bits[22]:0xff611; bits[7]:0x50
// args: bits[5]:0x1e; bits[18]:0x3bf65; bits[10]:0x1b5; bits[30]:0x15c05fc0; bits[9]:0x198; bits[17]:0x1988c; bits[29]:0x14b24cfe; bits[27]:0x732531d; bits[30]:0x22b04ba5; bits[20]:0x3db2a; bits[22]:0x1c17ef; bits[7]:0x42
// args: bits[5]:0x9; bits[18]:0x1ec6c; bits[10]:0x3da; bits[30]:0xf69b7de; bits[9]:0xdd; bits[17]:0x1b6ad; bits[29]:0x125a38d0; bits[27]:0x78412e1; bits[30]:0x338b52ef; bits[20]:0xf0d19; bits[22]:0x292969; bits[7]:0x5a
// args: bits[5]:0x18; bits[18]:0x2acc8; bits[10]:0x155; bits[30]:0x1d2a75e9; bits[9]:0x4a; bits[17]:0x13999; bits[29]:0xf48c311; bits[27]:0x7e6ca76; bits[30]:0x1e018836; bits[20]:0xf8abd; bits[22]:0x1496f3; bits[7]:0x36
// args: bits[5]:0x15; bits[18]:0x562c; bits[10]:0x7b; bits[30]:0x2d3e083e; bits[9]:0x151; bits[17]:0x14435; bits[29]:0x1afefe8c; bits[27]:0x619671c; bits[30]:0x3cd47138; bits[20]:0x748f5; bits[22]:0x85bd3; bits[7]:0x2a
// args: bits[5]:0x7; bits[18]:0x15555; bits[10]:0x100; bits[30]:0x379c111d; bits[9]:0xc8; bits[17]:0x5d0a; bits[29]:0x3782bcd; bits[27]:0x42ce95a; bits[30]:0x62bf070; bits[20]:0xeeee; bits[22]:0x386aba; bits[7]:0x7b
// args: bits[5]:0x9; bits[18]:0x31e66; bits[10]:0x1c0; bits[30]:0x36947d2a; bits[9]:0x1fb; bits[17]:0x10; bits[29]:0x12211d51; bits[27]:0x50d7227; bits[30]:0xde2b559; bits[20]:0x4f64c; bits[22]:0x188c1; bits[7]:0x71
// args: bits[5]:0x19; bits[18]:0x9489; bits[10]:0x309; bits[30]:0x1c660c70; bits[9]:0x36; bits[17]:0x164fe; bits[29]:0xc933385; bits[27]:0x1a2f745; bits[30]:0x17f70619; bits[20]:0x97166; bits[22]:0x111024; bits[7]:0x3f
// args: bits[5]:0x8; bits[18]:0x4dea; bits[10]:0x2fd; bits[30]:0x3d9960f7; bits[9]:0xad; bits[17]:0x176d3; bits[29]:0x384d939; bits[27]:0x75ea42e; bits[30]:0x8; bits[20]:0x55011; bits[22]:0x33f6ff; bits[7]:0x70
// args: bits[5]:0x19; bits[18]:0x2ef4b; bits[10]:0x127; bits[30]:0x1eba9357; bits[9]:0x61; bits[17]:0x200; bits[29]:0x4e3cab9; bits[27]:0x37e6a93; bits[30]:0x400; bits[20]:0xd86de; bits[22]:0x35407c; bits[7]:0x2
// args: bits[5]:0x1f; bits[18]:0xc062; bits[10]:0x3d6; bits[30]:0x173d32c5; bits[9]:0x1d8; bits[17]:0x2f08; bits[29]:0x66d3b8c; bits[27]:0x561c2f; bits[30]:0x2462ac46; bits[20]:0x9c335; bits[22]:0x3a9015; bits[7]:0x3f
// args: bits[5]:0x9; bits[18]:0x2a95b; bits[10]:0x3fb; bits[30]:0x22f897d4; bits[9]:0x13d; bits[17]:0x12e9b; bits[29]:0x179d7470; bits[27]:0x3abdd3e; bits[30]:0x2080b9d0; bits[20]:0x40000; bits[22]:0x8a5eb; bits[7]:0x8
// args: bits[5]:0xe; bits[18]:0x264da; bits[10]:0x155; bits[30]:0x110c7750; bits[9]:0x10; bits[17]:0x145b8; bits[29]:0x144f0f62; bits[27]:0x4000; bits[30]:0x1344f0c9; bits[20]:0x18d89; bits[22]:0x1d0811; bits[7]:0x5
// args: bits[5]:0x10; bits[18]:0x1b1e8; bits[10]:0x368; bits[30]:0x1042d07c; bits[9]:0x94; bits[17]:0x65e; bits[29]:0x35ec39d; bits[27]:0x1f3291; bits[30]:0x128cdbdb; bits[20]:0x2d172; bits[22]:0x29c599; bits[7]:0x21
// args: bits[5]:0x17; bits[18]:0x31c2e; bits[10]:0x8a; bits[30]:0x1000000; bits[9]:0xf4; bits[17]:0xb1f6; bits[29]:0xc006c27; bits[27]:0x2b8b3da; bits[30]:0x6dd7cde; bits[20]:0x1fb4e; bits[22]:0x165bb1; bits[7]:0x7f
// args: bits[5]:0x1; bits[18]:0x3cf99; bits[10]:0x1d5; bits[30]:0x268e2a24; bits[9]:0x7f; bits[17]:0xf299; bits[29]:0x172b2371; bits[27]:0x59dc976; bits[30]:0x3d068331; bits[20]:0xfc37a; bits[22]:0x396db6; bits[7]:0x36
// args: bits[5]:0x1c; bits[18]:0x251ea; bits[10]:0x96; bits[30]:0x34176232; bits[9]:0x92; bits[17]:0x1d934; bits[29]:0x4fee72a; bits[27]:0x66a2efc; bits[30]:0x5119b3d; bits[20]:0xe0494; bits[22]:0x21057e; bits[7]:0x7b
// args: bits[5]:0x1b; bits[18]:0x3ad99; bits[10]:0x1eb; bits[30]:0xa555f9b; bits[9]:0xd8; bits[17]:0x15984; bits[29]:0xb27719b; bits[27]:0x7b8547d; bits[30]:0x28a522e9; bits[20]:0x5a16d; bits[22]:0x30444; bits[7]:0x3
// args: bits[5]:0x11; bits[18]:0x1edf1; bits[10]:0x147; bits[30]:0x212bf7bc; bits[9]:0x48; bits[17]:0x8248; bits[29]:0x6a5b941; bits[27]:0x7f7174; bits[30]:0x1e9d07f7; bits[20]:0x400; bits[22]:0x6da58; bits[7]:0x6e
// args: bits[5]:0x1d; bits[18]:0x2d090; bits[10]:0x238; bits[30]:0x263949c5; bits[9]:0x110; bits[17]:0xffff; bits[29]:0x5015828; bits[27]:0x3c450a6; bits[30]:0x15555555; bits[20]:0x21437; bits[22]:0xdb21; bits[7]:0x2f
// args: bits[5]:0x1e; bits[18]:0x22022; bits[10]:0x158; bits[30]:0xbcccb97; bits[9]:0x18a; bits[17]:0xee2f; bits[29]:0xb058bb0; bits[27]:0x6653992; bits[30]:0xcb20dd5; bits[20]:0xfbfe7; bits[22]:0x27bd54; bits[7]:0x5c
// args: bits[5]:0x1b; bits[18]:0x37e4f; bits[10]:0x1a1; bits[30]:0x14ce318b; bits[9]:0x86; bits[17]:0x154cd; bits[29]:0x13f35d9b; bits[27]:0x535ec7; bits[30]:0x3345778e; bits[20]:0x742dc; bits[22]:0x21c86; bits[7]:0x3
// args: bits[5]:0x1d; bits[18]:0x8eee; bits[10]:0x3; bits[30]:0x125d38c4; bits[9]:0xd2; bits[17]:0x76d2; bits[29]:0x175522fb; bits[27]:0x2; bits[30]:0x1bd9b4c6; bits[20]:0x40000; bits[22]:0x18f4da; bits[7]:0x1
// args: bits[5]:0x8; bits[18]:0x1bbdc; bits[10]:0x374; bits[30]:0x193ea830; bits[9]:0xf0; bits[17]:0x8e3a; bits[29]:0x200; bits[27]:0x9be65c; bits[30]:0x25bac0f9; bits[20]:0x60748; bits[22]:0xa27ba; bits[7]:0x23
// args: bits[5]:0x17; bits[18]:0x42ac; bits[10]:0x312; bits[30]:0x17f5ea0c; bits[9]:0x1f9; bits[17]:0x0; bits[29]:0xf3287aa; bits[27]:0x5b78df9; bits[30]:0x16daf3cd; bits[20]:0x32289; bits[22]:0x3edf16; bits[7]:0x75
// args: bits[5]:0x18; bits[18]:0x32fc4; bits[10]:0x3fc; bits[30]:0x30aa651b; bits[9]:0x15c; bits[17]:0x1903d; bits[29]:0x69dd480; bits[27]:0xe1333b; bits[30]:0x4; bits[20]:0x8000; bits[22]:0x346209; bits[7]:0x33
// args: bits[5]:0x2; bits[18]:0x3cec2; bits[10]:0xb5; bits[30]:0x3963a68e; bits[9]:0x1b; bits[17]:0xeb5f; bits[29]:0x162fa30a; bits[27]:0x16446f8; bits[30]:0x1aa3c3ec; bits[20]:0x6550b; bits[22]:0x38d499; bits[7]:0x6
// args: bits[5]:0x2; bits[18]:0x1dc08; bits[10]:0x10; bits[30]:0xcef0637; bits[9]:0x31; bits[17]:0x138e2; bits[29]:0x1cde8697; bits[27]:0x3695b2b; bits[30]:0x2dce6e8b; bits[20]:0x3c91f; bits[22]:0x1c81ca; bits[7]:0x57
// args: bits[5]:0x1b; bits[18]:0x98ef; bits[10]:0x49; bits[30]:0x20ae2c85; bits[9]:0x8; bits[17]:0x800; bits[29]:0x1741fe9d; bits[27]:0x2007c9a; bits[30]:0x22ee262f; bits[20]:0x2bd54; bits[22]:0xe9b68; bits[7]:0x26
// args: bits[5]:0x12; bits[18]:0x20; bits[10]:0x35a; bits[30]:0x5d1db34; bits[9]:0x2; bits[17]:0x10478; bits[29]:0xaaf5023; bits[27]:0x73f634c; bits[30]:0x3f08d6f2; bits[20]:0xb1d2c; bits[22]:0x37cc7b; bits[7]:0x1e
// args: bits[5]:0xd; bits[18]:0x101ec; bits[10]:0x194; bits[30]:0x8000000; bits[9]:0x82; bits[17]:0xe6ad; bits[29]:0x9b0475c; bits[27]:0x33699c8; bits[30]:0x14e4add4; bits[20]:0x716b9; bits[22]:0x3c5e78; bits[7]:0x79
// args: bits[5]:0x2; bits[18]:0x2d69; bits[10]:0x23a; bits[30]:0x1c82b667; bits[9]:0x27; bits[17]:0x15aa9; bits[29]:0x8f8ab65; bits[27]:0x609595f; bits[30]:0x2192c9fe; bits[20]:0xaa838; bits[22]:0x200000; bits[7]:0x44
// args: bits[5]:0x4; bits[18]:0x9489; bits[10]:0xbb; bits[30]:0x3fffffff; bits[9]:0xfa; bits[17]:0x7499; bits[29]:0x7ae8693; bits[27]:0x6432e65; bits[30]:0x698a290; bits[20]:0x87494; bits[22]:0x8; bits[7]:0x78
// args: bits[5]:0x16; bits[18]:0x22fe4; bits[10]:0x3e2; bits[30]:0x35ec7104; bits[9]:0x1e5; bits[17]:0x78e8; bits[29]:0xa0eb32c; bits[27]:0x8ebb17; bits[30]:0x186961b3; bits[20]:0xcc060; bits[22]:0x22f711; bits[7]:0x6b
// args: bits[5]:0x1e; bits[18]:0x1ac81; bits[10]:0x71; bits[30]:0x19a7465b; bits[9]:0x9b; bits[17]:0x128c4; bits[29]:0x200000; bits[27]:0x4b50a70; bits[30]:0x20ab4a44; bits[20]:0x60613; bits[22]:0xafb95; bits[7]:0x2e
// args: bits[5]:0x17; bits[18]:0x192c6; bits[10]:0xe3; bits[30]:0x176759df; bits[9]:0x136; bits[17]:0x80; bits[29]:0x14965106; bits[27]:0x3fb91ec; bits[30]:0x1e798e16; bits[20]:0x2e934; bits[22]:0x79dc0; bits[7]:0x5c
// args: bits[5]:0xd; bits[18]:0x2220e; bits[10]:0x21a; bits[30]:0x48e6dfd; bits[9]:0x1ed; bits[17]:0x8; bits[29]:0x10751312; bits[27]:0x287f4c0; bits[30]:0xfd225b4; bits[20]:0xde5ab; bits[22]:0x3ed121; bits[7]:0x2a
// args: bits[5]:0x1f; bits[18]:0x1; bits[10]:0x38e; bits[30]:0x653372f; bits[9]:0x164; bits[17]:0x19166; bits[29]:0x8; bits[27]:0x46ea01a; bits[30]:0x1f34d2c3; bits[20]:0xb4b9d; bits[22]:0xb1912; bits[7]:0x28
// args: bits[5]:0x10; bits[18]:0x279ba; bits[10]:0x20d; bits[30]:0x1d8af72e; bits[9]:0x159; bits[17]:0x100; bits[29]:0x16874ea3; bits[27]:0x36be573; bits[30]:0x2c8ad71a; bits[20]:0x2b9af; bits[22]:0x1; bits[7]:0x2e
// args: bits[5]:0x19; bits[18]:0x3a1a9; bits[10]:0x262; bits[30]:0x3667f717; bits[9]:0x110; bits[17]:0x1d9b3; bits[29]:0x99e032d; bits[27]:0x200000; bits[30]:0x398fb2f9; bits[20]:0xb4e59; bits[22]:0x7d751; bits[7]:0x2a
// args: bits[5]:0x1d; bits[18]:0x223b8; bits[10]:0x12b; bits[30]:0x36756779; bits[9]:0x162; bits[17]:0x720; bits[29]:0x8198a0f; bits[27]:0x700fd34; bits[30]:0x3d4db8ca; bits[20]:0xce91b; bits[22]:0x27d398; bits[7]:0x2
// args: bits[5]:0x14; bits[18]:0x7dc; bits[10]:0x2c2; bits[30]:0x3fffffff; bits[9]:0x19b; bits[17]:0x12c0c; bits[29]:0x90bab2; bits[27]:0x3613287; bits[30]:0x8dd37f8; bits[20]:0x5702d; bits[22]:0x40; bits[7]:0x1d
// args: bits[5]:0x17; bits[18]:0x35bec; bits[10]:0x22; bits[30]:0x22e5cd98; bits[9]:0x167; bits[17]:0x7f54; bits[29]:0x1a2da29f; bits[27]:0xbbafd; bits[30]:0x75409c6; bits[20]:0x32bee; bits[22]:0x398d9f; bits[7]:0xc
// args: bits[5]:0x9; bits[18]:0x38caa; bits[10]:0xd0; bits[30]:0x3ec92a99; bits[9]:0x8d; bits[17]:0x14448; bits[29]:0x1d2edb5c; bits[27]:0x1c185b7; bits[30]:0x1ea9cd77; bits[20]:0xf210e; bits[22]:0x34cccf; bits[7]:0x26
// args: bits[5]:0xe; bits[18]:0x3ade3; bits[10]:0x0; bits[30]:0x297bd6b5; bits[9]:0xed; bits[17]:0xa25; bits[29]:0x1848cbb9; bits[27]:0x3c7aff6; bits[30]:0x2000; bits[20]:0x5f386; bits[22]:0x12cecc; bits[7]:0x59
// args: bits[5]:0x18; bits[18]:0x128ad; bits[10]:0x34b; bits[30]:0xadf1ef6; bits[9]:0x106; bits[17]:0xb439; bits[29]:0x184adcf6; bits[27]:0x25e2b6a; bits[30]:0x2e8da715; bits[20]:0xfc936; bits[22]:0x220d8e; bits[7]:0x2e
// args: bits[5]:0x13; bits[18]:0x1718; bits[10]:0x271; bits[30]:0xce7df46; bits[9]:0xde; bits[17]:0x11517; bits[29]:0x18ff9a08; bits[27]:0x2241175; bits[30]:0xf53e7b6; bits[20]:0xee976; bits[22]:0x1e52e8; bits[7]:0x1b
// args: bits[5]:0x9; bits[18]:0x1; bits[10]:0x227; bits[30]:0x3177a3e0; bits[9]:0x1b7; bits[17]:0x20; bits[29]:0x1f21dec9; bits[27]:0x65260d0; bits[30]:0x32615c4a; bits[20]:0x2de55; bits[22]:0x312a33; bits[7]:0x24
// args: bits[5]:0xe; bits[18]:0x105d4; bits[10]:0x1da; bits[30]:0xe750926; bits[9]:0x36; bits[17]:0x1981d; bits[29]:0xe1e2861; bits[27]:0x2cb5d4d; bits[30]:0x3e6d1c47; bits[20]:0x1654c; bits[22]:0x2a41fa; bits[7]:0x71
// args: bits[5]:0x2; bits[18]:0x1db97; bits[10]:0x19c; bits[30]:0x384a40a; bits[9]:0x13f; bits[17]:0x1b9a1; bits[29]:0x1c1ae385; bits[27]:0x5fe3ff0; bits[30]:0x285c55e1; bits[20]:0xfffff; bits[22]:0x23c7c3; bits[7]:0xb
// args: bits[5]:0x15; bits[18]:0x374a9; bits[10]:0x31; bits[30]:0x3c76eebf; bits[9]:0x164; bits[17]:0x8d70; bits[29]:0x1aaaa97f; bits[27]:0x25fb504; bits[30]:0x4; bits[20]:0xa909a; bits[22]:0x1b96b8; bits[7]:0x28
// args: bits[5]:0x10; bits[18]:0x6e28; bits[10]:0x309; bits[30]:0x2932a6e7; bits[9]:0x47; bits[17]:0x2000; bits[29]:0x1c666aa3; bits[27]:0x2cf74; bits[30]:0xf4b51ec; bits[20]:0x5837c; bits[22]:0x10000; bits[7]:0x49
// args: bits[5]:0x7; bits[18]:0x2244d; bits[10]:0x393; bits[30]:0x1be0a62c; bits[9]:0xaa; bits[17]:0x1d772; bits[29]:0x9040a32; bits[27]:0x21693e4; bits[30]:0x2977f49d; bits[20]:0x64521; bits[22]:0x8abb; bits[7]:0x62
// args: bits[5]:0x10; bits[18]:0x20000; bits[10]:0x76; bits[30]:0x13a46666; bits[9]:0x18f; bits[17]:0x1fbcf; bits[29]:0xe1f7e72; bits[27]:0x525a954; bits[30]:0x2c96cbad; bits[20]:0x543ae; bits[22]:0x1a885c; bits[7]:0x5b
// args: bits[5]:0x2; bits[18]:0x28e4d; bits[10]:0x2c1; bits[30]:0xf8a88d4; bits[9]:0xff; bits[17]:0x1c600; bits[29]:0x1bb7907f; bits[27]:0x53b545e; bits[30]:0x3b812ca7; bits[20]:0x91953; bits[22]:0x7923b; bits[7]:0xa
// args: bits[5]:0x1f; bits[18]:0x1d4d3; bits[10]:0x1b5; bits[30]:0x32dff9e8; bits[9]:0x191; bits[17]:0x119bc; bits[29]:0xd3870d7; bits[27]:0x3618d09; bits[30]:0xdcffb7b; bits[20]:0x647ae; bits[22]:0x8; bits[7]:0x6a
// args: bits[5]:0xf; bits[18]:0x800; bits[10]:0x142; bits[30]:0x335f2233; bits[9]:0x157; bits[17]:0xd82e; bits[29]:0x10ce5927; bits[27]:0x74a3959; bits[30]:0x24d98014; bits[20]:0xc1d9f; bits[22]:0x18f42b; bits[7]:0xe
// args: bits[5]:0x11; bits[18]:0x1ad6e; bits[10]:0x3af; bits[30]:0x2e0589ef; bits[9]:0x96; bits[17]:0x126e5; bits[29]:0x80; bits[27]:0x414416f; bits[30]:0x330602b4; bits[20]:0x14c0d; bits[22]:0x231493; bits[7]:0x28
fn main(x0: u5, x1: u18, x2: u10, x3: u30, x4: u9, x5: u17, x6: u29, x7: u27, x8: u30, x9: u20, x10: u22, x11: u7) -> u1 {
    let x12: u30 = (x3) - (x3);
    let x13: u30 = -(x3);
    let x14: u30 = -(x12);
    let x15: u27 = -(x7);
    let x16: u5 = (x0) & ((x6) as u5);
    let x17: u1 = (u1:0x1);
    let x18: u1 = -(x17);
    x18
}


