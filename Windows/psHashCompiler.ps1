$rootpath = $HOME
$pathway = $(Read-Host "Where is the target file")
Set-Location $rootpath\$pathway
$hpath = "$rootpath\GitHub\hashes"
Write-Host $hpath
$htarget = Read-Host "What file are you hashing?"
$htext = Read-Host "What do you want your file called?"
$htext = "$htext.txt"
Get-FileHash -Algorithm SHA256 $htarget | Select-Object -ExpandProperty Hash | Out-File "$hpath\$htext"
