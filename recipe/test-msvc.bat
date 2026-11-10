@setlocal DisableDelayedExpansion

@if /i not "%CARGO_BUILD_TARGET%" == "%~1" exit /b 1
@if /i not "%CONDA_RUST_HOST%" == "%~2" exit /b 1
@if /i not "%CONDA_RUST_TARGET%" == "%~2" exit /b 1

@set "ACTIVATE_SCRIPT=%PREFIX%\etc\conda\activate.d\activate-rust_%~3.bat"
@powershell -NoProfile -Command "$ErrorActionPreference = 'Stop'; if ((Get-Content -Raw -LiteralPath $env:ACTIVATE_SCRIPT).Contains('@rust_arch')) { exit 1 }"
@if errorlevel 1 exit /b 1

@set "LD="
@call "%ACTIVATE_SCRIPT%"
@if errorlevel 1 exit /b 1
@call set "LINKER=%%CARGO_TARGET_%~2_LINKER%%"
@if /i not "%LINKER%" == "link.exe" exit /b 1

@set "CARGO_TARGET_DIR=%CD%\rust-activation-target"
@cargo new --bin --offline rust-activation-test
@if errorlevel 1 exit /b 1
@cargo build --offline --manifest-path rust-activation-test\Cargo.toml
@if errorlevel 1 exit /b 1
@"%CARGO_TARGET_DIR%\%~1\debug\rust-activation-test.exe"
@if errorlevel 1 exit /b 1

@set "LD=C:\Program Files\LLVM\bin\lld-link.exe"
@call "%ACTIVATE_SCRIPT%"
@if errorlevel 1 exit /b 1
@call set "LINKER=%%CARGO_TARGET_%~2_LINKER%%"
@if not "%LINKER%" == "%LD%" exit /b 1

@cargo --list
@if errorlevel 1 exit /b 1
@endlocal
@exit /b 0
