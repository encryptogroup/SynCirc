# FRESH: Framework for Efficient Secure Circuit Synthesis from High-Level Languages

This repository contains the code for our paper. Our framework
consists of 3 components:

- Yosys[3], an open-source Verilog synthesis suite
- XLS[0], an open-source High-Level Synthesis toolchain
- FRESH toolchain, our work providing a convenient development
  experience for programming multiplicative-depth-optimized MPC
  circuits

## Instructions

We provide a Jupyter notebook `fresh.ipynb` for easy testing of our
circuit compilation workflow. This notebook can be conveniently
executed in [Google Colab](https://colab.research.google.com) by
uploading the `fresh.ipynb` notebook.

The Jupyter notebook uses pre-built binaries in order to speed up
compilation. Information on reproducing these binaries is available in
the Appendix.

You can also run the notebook in a Docker container locally:

```bash
DOCKER_IMAGE=$(docker build . -q -f Dockerfile.notebook)
docker run --rm -p 8889:8888 -v "$(pwd):/home/jovyan/work" $DOCKER_IMAGE start-notebook.py --NotebookApp.token='my-token'
```

Then head to http://localhost:8889. The notebook also works on
Ubuntu-like host systems, but be aware that it installs various
dependencies such as Yosys[5].

## Detailed instructions for manual reproducing without Docker

### Dependencies

#### XLS

XLS is built using the Bazel build system[1]. The Bazel website has
instructions for installing Bazel on different systems:
https://bazel.build/install/. Additionally the following packages are
needed (exact names may vary in your distribution):

- A C++ compiler supporting C++17
- `python3-distutils`
- `python3-dev`
- `libtinfo5`
- `python-is-python3`

#### FRESH toolchain

The FRESH toolchain requires a 0.10.0 release of the Zig[2]
compiler. Assuming a x86_64 Linux machine, the following commands will
download and extract a Zig compiler binary. Binaries for other systems
are available under https://ziglang.org/download/.

```bash
wget https://ziglang.org/download/0.10.0/zig-linux-x86_64-0.10.0.tar.xz
tar xf zig-linux-x86_64-0.10.0.tar.xz
```

### Building

#### XLS

After running the following command, various XLS tools will be present
in the `bazel-bin` directory. This may take multiple hours.

```bash
cd xls
bazel build -- //xls/dslx:ir_converter_main //xls/tools:opt_main //xls/tools:codegen_main //xls/contrib/xlscc:xlscc
```

#### FRESH toolchain

The following shell command will build the FRESH toolchain. All
executables will be present in the `zig-out/bin` directory.

```bash
zig-linux-x86_64-0.10.0/zig build
```

### Testing

The following command will run the entire test suite included in the
compiler subdirectory.

```bash
zig-linux-x86_64-0.10.0/zig build test
```

## References

[0] https://google.github.io/xls/

[1] https://bazel.build/

[2] https://ziglang.org/

[3] https://yosyshq.net/yosys/

## Appendix

### Pre-built binary dependencies

As the build process of XLS[1] involves compiling LLVM and Clang from
source, this process is time-consuming, even on powerful machines. For
this reason, we provide pre-compiled binaries, which are downloaded by
the Jupyter notebook. These binaries can be reproduced locally using
Docker:

```bash
docker build . -f Dockerfile.xls
```

After completion, copy the binaries from the container image into your
local system.
