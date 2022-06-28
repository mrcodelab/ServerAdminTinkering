$b = 'C:\Program Files\zAdmin'
try {
    Start-Process powershell -Verb RunAs Administrator
    Install-Module -Name PSWindowsUpdate
    Get-Help
}
finally {
    if ( Test-Path -Path $b ) {
        Write-Host "The folder already exists."
    }
    else {
        mkdir $b
        Move-Item -Force $HOME\Downloads\w10_pc_tuneup $b
    }

    Set-Location $b
    powershell.exe w10_pc_tuneup
}