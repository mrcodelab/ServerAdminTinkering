@REM This will theoretically call a pair of undocumented rundll commands as command line

cmd.exe
"C:\Windows\system32\rundll32.exe" && "C:\Windows\system32\WININET.dll",DispatchAPICall 3
