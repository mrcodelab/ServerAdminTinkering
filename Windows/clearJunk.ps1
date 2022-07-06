Clear-RecycleBin -DriveLetter C -Force
Set-Location $HOME\Downloads
Remove-Item *.zip, *.gz, *.exe, *.msi,
*.txt, *.png, *.jpg, *.eml, *.msg -Force