if not defined CARGO_HOME set "CARGO_HOME=%CONDA_PREFIX%\.cargo"
if not defined CARGO_CONFIG set "CARGO_CONFIG=%CARGO_HOME%\config"
if not defined RUSTUP_HOME set "RUSTUP_HOME=%CARGO_HOME%\rustup"

if not exist "%CARGO_HOME%" mkdir "%CARGO_HOME%"

set "CARGO_BUILD_TARGET=@rust_arch@"
set "CONDA_RUST_HOST=@rust_arch_env_build@"
set "CONDA_RUST_TARGET=@rust_arch_env@"

set "CARGO_TARGET_@rust_arch_env_build@_LINKER=link.exe"

set "CARGO=%CONDA_PREFIX%\Library\bin\cargo"
set "RUSTC=%CONDA_PREFIX%\Library\bin\rustc"
set "RUSTDOC=%CONDA_PREFIX%\Library\bin\rustdoc"

if not defined CARGO_INSTALL_ROOT set "CARGO_INSTALL_ROOT=%CONDA_PREFIX%\Library"

if not defined LD (
    set "CARGO_TARGET_@rust_arch_env@_LINKER=link.exe"
) else (
    set "CARGO_TARGET_@rust_arch_env@_LINKER=%LD%"
)