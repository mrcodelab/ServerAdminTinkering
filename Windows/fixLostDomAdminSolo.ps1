#I’m only going to help if you promise to setup a second Domain Admin.
#
#This is assuming you have the Bitlocker key, or you don’t use Bitlocker.
#
Write-Host "PRINT THESE INSTRUCTIONS or OPEN ON ANOTHER SYSTEM"
Write-Host "Download server 2016 ISO > attach to VM > reboot into ISO > Repair your Computer > Troubleshoot > Command prompt"

cd C:\Windows\System32

ren osk.exe osk.old

copy C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe osk.exe

#Reboot the server, launch the on screen keyboard and Powershell will open

Net user Administrator PASSWORD

#Make sure you reverse the file changes after.
