if /i "%PKG_NAME%" == "rust_win-64" (
    set "rust_arch=x86_64-pc-windows-msvc"
    set "rust_arch_env=X86_64_PC_WINDOWS_MSVC"
) else if /i "%PKG_NAME%" == "rust_win-arm64" (
    set "rust_arch=aarch64-pc-windows-msvc"
    set "rust_arch_env=AARCH64_PC_WINDOWS_MSVC"
) else (
    exit /b 1
)

if not exist "%PREFIX%\etc\conda\activate.d" (
    mkdir "%PREFIX%\etc\conda\activate.d"
    if errorlevel 1 exit /b 1
)

rem Replace the template's Rust target placeholders when installing the activation script.
powershell -NoProfile -Command "$ErrorActionPreference = 'Stop'; (Get-Content -LiteralPath (Join-Path $env:RECIPE_DIR 'activate-msvc.bat') -Raw) -replace '@rust_arch_env_build@', $env:rust_arch_env -replace '@rust_arch_env@', $env:rust_arch_env -replace '@rust_arch@', $env:rust_arch | Set-Content -LiteralPath (Join-Path $env:PREFIX ('etc\conda\activate.d\activate-' + $env:PKG_NAME + '.bat')) -NoNewline"
if errorlevel 1 exit /b 1
