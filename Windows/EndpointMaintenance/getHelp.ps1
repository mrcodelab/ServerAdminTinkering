"""
This script will generate a help message with the:
1) Description of the problem
2) Username
3) Host name
Then it will send the file to the help desk using Outlook COM object functionality
"""
$issue = Read-Host "Please describe the issue you need help with:
"
Write-Host "
Wait a moment while I gather system info and generate your help file."
$tgt = "$HOME\Downloads\helpfile.txt"
Write-Host ""

$bodyHeader = Write-Output "User:
$env:USERNAME
needs help on workstation:
$env:COMPUTERNAME.
"

$bodyIssue = Write-Output "Please assist with:
$issue"

# Automated send help file with request to the help desk shared mailbox
$toaddress = "matthew.rhoda@arcfield.com"
$Subject = "Help $env:USERNAME"
$body = $bodyHeader + $bodyIssue

try {
    $Outlook = New-Object -ComObject Outlook.Application
    $Mail = $Outlook.CreateItem()
    $Mail.To = $toaddress
    $Mail.Subject = $Subject
    $Mail.Body = $body
    $Mail.Send()
    $Outlook.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Outlook) | Out-Null

    Write-Host "Your help file has been generated and sent to the help desk." -ForegroundColor Green
}
catch {
    Write-Host "Could not send message using Outlook, sorry.
    Please send the helpfile.txt file from Downloads manually." -ForegroundColor Red
    Write-Output $body | Out-File $tgt
}
Start-Sleep -Seconds 7
Write-Host "Goodbye."
Exit