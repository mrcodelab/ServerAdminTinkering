$optionsList = @("Original Control Panel", "Internet Options", "Programs", "File History", "User Accounts",
                "Device Manager", "Printers", "Display Settings", "Network Settings", "Power Settings",
                "Security & Maintenance", "System Properties", "Windows Defender Firewall")
Write-Host "I have indexed: " 
$optionsList

$lostoption = Read-Host "What option are you looking for?"

if ($lostoption -eq $optionsList[0]) {
    Write-Host "Launching the original control panel for you."
    control.exe
}
elseif ($lostoption -eq $optionsList[1]) {
    Write-Host "Launching Internet Options for you."
    inetcpl.cpl
}
elseif ($lostoption -eq $optionsList[2]) {
    Write-Host "Launching Programs control panel for you."
    appwiz.cpl
}
elseif ($lostoption -eq $optionsList[3]) {
    Write-Host "Launching File History for you."
    FileHistory.exe
}
elseif ($lostoption -eq $optionsList[4]) {
    Write-Host "Launching User Accounts for you."
    Netplwiz.exe
}
elseif ($lostoption -eq $optionsList[5]) {
    Write-Host "Launching Admin Tools for you."
    devmgmt.msc
}
elseif ($lostoption -eq $optionsList[6]) {
    Write-Host "Launching Printers for you."
    printmanagement.msc
}
elseif ($lostoption -eq $optionsList[7]) {
    Write-Host "Launching Display Settings for you."
    desk.cpl
}
elseif ($lostoption -eq $optionsList[8]) {
    Write-Host "Launching Network settings for you."
    ncpa.cpl
}
elseif ($lostoption -eq $optionsList[9]) {
    Write-Host "Launching Power Management for you."
    powercfg.cpl
}
elseif ($lostoption -eq $optionsList[10]) {
    Write-Host "Launching security and maintenance config for you."
    wscui.cpl
}
elseif ($lostoption -eq $optionsList[11]) {
    Write-Host "Launching system properties for you."
    sysdm.cpl
}
elseif ($lostoption -eq $optionsList[12]) {
    Write-Host "Launching Windows Defender firewall config for you."
    Firewall.cpl
}
else {
    Write-Host "Sorry, I don't have what you entered. Goodbye"
    Start-Sleep -Seconds 11
}