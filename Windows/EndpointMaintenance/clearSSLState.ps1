# This will theoretically call a pair of undocumented rundll commands as command line

rundll32.exe; wininit.exe -DispatchAPICall 3
Write-Output "SSL State Cleared"
# "C:\Windows\system32\rundll32.exe" && "C:\Windows\system32\WININET.dll",DispatchAPICall 3