#!/bin/bash -e -x

rustc --help
rustdoc --help
cargo --help

echo "#!/usr/bin/env bash"                         > ./cc
if [[ ${target_platform} =~ linux.*aarch64* ]]; then
  echo "aarch64-conda-linux-gnu-cc \"\$@\""   >> ./cc
elif [[ ${target_platform} =~ linux.* ]]; then
  echo "x86_64-conda-linux-gnu-cc \"\$@\""   >> ./cc
elif [[ ${target_platform} == osx-arm64 ]]; then
  echo "arm64-apple-darwin20.0.0-clang \"\$@\""  >> ./cc
fi

cat cc
chmod +x cc

mkdir ~/tmp-cargo || true
export CARGO_TARGET_DIR=~/tmp-cargo 
cargo install xsv --force -vv
