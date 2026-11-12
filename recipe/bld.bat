mkdir %PREFIX%\etc\conda\activate.d
copy %RECIPE_DIR%\activate-msvc.bat %PREFIX%\etc\conda\activate.d\activate-%PKG_NAME%.bat
