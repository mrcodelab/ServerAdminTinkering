$c = $env:COMPUTERNAME
Write-Host $c "Has the following OS name and build version:"
# Get-ComputerInfo | Select-Object -ExpandProperty OsName; Get-ComputerInfo | Select-Object -ExpandProperty OsBuildNumber
$osName = Get-ComputerInfo | Select-Object -ExpandProperty OsName
$osBuild = Get-ComputerInfo | Select-Object -ExpandProperty OsBuildNumber
Write-Output "$c,$osName,$osBuild" | Out-File -Append $HOME\Documents\osInfo.txt
Write-Host $osName
Write-Host $osBuild