@REM This is dumping the MS Teams folder to force a reinstall of cached content from the server.

cd %AppData%\Microsoft\ && rmdir /s /q Teams\ && echo removed the Teams folder && timeout 5