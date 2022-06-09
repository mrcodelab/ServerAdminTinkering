"""Basics of powershell"""

# list all powershell commands
Get-Command

# get help with a specific process
Get-Help -Name <process>

# Powershell version
$PSVersionTable

# host system execution policy
Get-ExecutionPolicy

"""Powershell wants to be linux so bad it hurts. Meet the | less tool"""
Get-Process | less

# pwd in Powershell:
Get-Location
# touch in Powershell:
new-item TestFile.txt
# using the > tofile
set-content TestFile.txt -value "Infosec rocks!"
# rm <file>
remove-item TestFile.txt
