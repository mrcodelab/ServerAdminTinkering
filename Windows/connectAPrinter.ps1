"""
This script will remove all non-Microsoft print utilities.
Then it will add the $printer printer and set it as the default.
"""
$proceed = Read-Host "Are you sure you want to remove all printers and add the $printer printer? (Y/N)"
$proceed = $proceed.ToUpper()
if($proceed -ne "Y"){
    Write-Host "Exiting without making changes."
    Start-Sleep -Seconds 2
    Exit
}

$mkList = Get-Printer | Select-Object -ExpandProperty Name
$mkList = @($mkList)
$listAll = @()

for($i=0;$i -le ($mkList.Count); $i++){
    $listAll += $mkList[$i]
}

$rmList = @()

for ($i=0;$i -lt ($listAll.Count - 1); $i++){
    if (($listAll[$i].Contains("Microsoft")) -or ($listAll[$i].Contains("OneNote")) -or ($listAll[$i].Contains("Fax"))){
        Write-Host "Not removing the MS native print utilities:" $listAll[$i]
    }
    else{
        $rmList += $listAll[$i]
    }
}
$rmList = @($rmList)

for ($i=0;$i -lt $rmList.Count;$i++){
    Write-Host "Removing printer: "$rmList[$i]
    Remove-Printer $rmList[$i]
}
Write-Host "Adding the desired printer."
$printerName = "test"
$setDefPrinter = (Get-CimInstance -ClassName CIM_Printer | Where-Object {$_.Name -eq $printerName}[0])
$prtDefault | Invoke-CimMethod -MethodName SetDefaultPrinter | Out-Null
function selfdest{
    Set-Location $HOME\Downloads
    Remove-Item *.ps1 -Force
}
selfdest