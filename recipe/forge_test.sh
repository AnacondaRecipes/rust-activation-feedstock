#!/bin/bash -e -x

rustc --help
rustdoc --help
cargo --help

echo "#!/usr/bin/env bash"                         > ./cc
if [[ ${target_platform} =~ linux.*390x.* ]]; then
   echo "s390x-conda_cos7-linux-gnu-cc \"\$@\""   >> ./cc
elif [[ ${target_platform} =~ linux.*aarch64* ]]; then
  echo "aarch64-conda-linux-gnu-cc \"\$@\""   >> ./cc
elif [[ ${target_platform} =~ linux.* ]]; then
  echo "x86_64-conda_cos7-linux-gnu-cc \"\$@\""   >> ./cc
elif [[ ${target_platform} == osx-64 ]]; then
  echo "x86_64-apple-darwin13.4.0-clang \"\$@\""  >> ./cc
  export CONDA_BUILD_SYSROOT=/opt/MacOSX10.10.sdk
elif [[ ${target_platform} == osx-arm64 ]]; then
  echo "arm64-apple-darwin20.0.0-clang \"\$@\""  >> ./cc
fi
cat cc
chmod +x cc

mkdir ~/tmp-cargo || true
CARGO_TARGET_DIR=~/tmp-cargo PATH="$PWD:$PATH" cargo install xsv --force -vv
