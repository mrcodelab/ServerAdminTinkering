$optionsList = @("Original Control Panel", "Internet Options", "Programs", "File History", "User Accounts",
                "Device Manager", "Printers", "Display Settings", "Network Settings", "Power Settings",
                "Security & Maintenance", "System Properties", "Windows Defender Firewall")
Write-Host "I have indexed the following options.
Which control panel item are you looking for?"
Start-Sleep -Seconds 1
for($i=0;$i -le ($optionsList.Count - 1); $i++){
    Write-Host ($i + 1) $optionsList[$i]
}

$lostoption = Read-Host "
Please enter the number of your choice"

switch ($lostoption) {
    1 {Write-Host "Launching the original control panel for you."; control.exe}
    2 {Write-Host "Launching Internet Options for you."; inetcpl.cpl }
    3 {Write-Host "Launching Programs control panel for you."; appwiz.cpl }
    4 {Write-Host "Launching File History for you."; FileHistory.exe }
    5 {Write-Host "Launching User Accounts for you."; Netplwiz.exe }
    6 {Write-Host "Launching Admin Tools for you."; devmgmt.msc }
    7 {Write-Host "Launching Printers for you."; printmanagement.msc }
    8 {Write-Host "Launching Display Settings for you."; desk.cpl }
    9 {Write-Host "Launching Network settings for you."; ncpa.cpl }
    10 {Write-Host "Launching Power Management for you."; powercfg.cpl }
    11 {Write-Host "Launching security and maintenance config for you."; wscui.cpl }
    12 {Write-Host "Launching system properties for you."; sysdm.cpl }
    13 {Write-Host "Launching Windows Defender firewall config for you."; Firewall.cpl }
    Default {
        Write-Host "Sorry, I don't have what you entered. Goodbye"
        Start-Sleep -Seconds 3
        Exit
    }
}