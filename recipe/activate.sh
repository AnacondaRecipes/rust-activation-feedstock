#!/usr/bin/env bash

export CARGO_HOME=${CONDA_PREFIX}/.cargo.$(uname)
export CARGO_CONFIG=${CARGO_HOME}/config
export RUSTUP_HOME=${CARGO_HOME}/rustup

case "$(uname -sp)" in
"Linux aarch64")
    rust_arch="aarch64-unknown-linux-gnu"
    ;;
"Linux x86_64")
    rust_arch="x86_64-unknown-linux-gnu"
    ;;
"Darwin i386")
    rust_arch="x86_64-apple-darwin"
    ;;
"Darwin arm")
    rust_arch="aarch64-apple-darwin"
    ;;
*)
    rust_arch=""
    ;;
esac

export RUSTFLAGS=""
# set flags for arch-dependent rust-std toolchain
if [[ -n "$rust_arch" && -d ${CONDA_PREFIX}/lib/rustlib/${rust_arch} ]]; then
    export RUSTFLAGS="-L ${CONDA_PREFIX}/lib/rustlib/${rust_arch}/lib"
fi

# detect wasm32 toolchain
for PATH_ENDING in 1 2; do
    wasm32dir="${CONDA_PREFIX}/lib/rustlib/wasm32-wasip${PATH_ENDING}"
    if [[ -d ${wasm32dir} ]]; then
        export RUSTFLAGS="${RUSTFLAGS} -L ${wasm32dir}/lib"
        break
    fi
done

[[ -d ${CARGO_HOME} ]] || mkdir -p ${CARGO_HOME}

if [[ $(uname) == Darwin ]]; then
  echo "You may want to add this to /etc/launchd.conf for VSCode"
  echo "..  but actually it seems to source ~/.bash_profile for you so maybe better to just export these vars there (and conda activate devenv)"
  echo "setenv RUSTUP_HOME ${RUSTUP_HOME}"
  echo "setenv CARGO_HOME ${CARGO_HOME}"
  echo "setenv CARGO_CONFIG ${CARGO_CONFIG}"
fi

echo "[target.aarch64-apple-darwin]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/arm64-apple-darwin20.0.0-clang\"" >> ${CARGO_CONFIG}
echo "[target.x86_64-apple-darwin]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/x86_64-apple-darwin13.4.0-clang\"" >> ${CARGO_CONFIG}
echo "[target.i686-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/i686-conda_cos6-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "[target.x86_64-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/x86_64-conda_cos7-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "[target.powerpc64le-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/powerpc64le-conda_cos7-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "[target.s390x-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/s390x-conda_cos7-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "[target.aarch64-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/aarch64-conda-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "[target.'cfg(...)']" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-flags=-Wl,-rpath-link=${CONDA_PREFIX}/lib,-rpath=${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}


echo "[target.arm64-apple-darwin20.0.0]" > ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/arm64-apple-darwin20.0.0-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}
echo "[target.aarch64-apple-darwin]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/arm64-apple-darwin20.0.0-clang\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}

echo "[target.x86_64-apple-darwin13.4.0]" > ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/x86_64-apple-darwin13.4.0-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}
echo "[target.x86_64-apple-darwin]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/x86_64-apple-darwin13.4.0-clang\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}
echo "[target.i686-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/i686-conda_cos6-linux-gnu-cc\"" >> ${CARGO_CONFIG}
# -static-libgcc not seem to work, not sure we should care (from an AD packaging perspective, just make it depend on libgcc-ng and be happy).
# echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath-link,${CONDA_PREFIX}/lib\", \"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=s\", \"-C\", \"link-arg=-static-libgcc\"]" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath-link,${CONDA_PREFIX}/lib\", \"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=s\"]" >> ${CARGO_CONFIG}
echo "[target.x86_64-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/x86_64-conda_cos7-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath-link,${CONDA_PREFIX}/lib\", \"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=s\"]" >> ${CARGO_CONFIG}
echo "[target.powerpc64le-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/powerpc64le-conda_cos7-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath-link,${CONDA_PREFIX}/lib\", \"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=s\"]" >> ${CARGO_CONFIG}
echo "[target.s390x-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/s390x-conda_cos7-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath-link,${CONDA_PREFIX}/lib\", \"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=s\"]" >> ${CARGO_CONFIG}
echo "[target.aarch64-unknown-linux-gnu]" >> ${CARGO_CONFIG}
echo "linker = \"${CONDA_PREFIX}/bin/aarch64-conda-linux-gnu-cc\"" >> ${CARGO_CONFIG}
echo "rustflags = [\"-C\", \"link-arg=-Wl,-rpath-link,${CONDA_PREFIX}/lib\", \"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=s\"]" >> ${CARGO_CONFIG}
echo "# Not sure about this stuff:" >> ${CARGO_CONFIG}
echo "# [target.'cfg(...)']" >> ${CARGO_CONFIG}
echo "# [build]" >> ${CARGO_CONFIG}
echo "# rustflags = [\"-C\", \"link-arg=-Wl,-rpath,${CONDA_PREFIX}/lib\", \"-C\", \"opt-level=z\"]" >> ${CARGO_CONFIG}

export PATH=${CARGO_HOME}/bin:${PATH}
