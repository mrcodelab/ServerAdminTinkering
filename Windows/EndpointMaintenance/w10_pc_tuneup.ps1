﻿#version MAJ.MIN.r.yyyymo
#version 2.2.2.202206
$version = "2.2.2.202206"
$u = $env:UserName
$c = $env:COMPUTERNAME
Write-Output "Hi $u. "
$b = "C:\Program Files\zAdmin"
$h = "C:\Windows\System32\drivers\etc\hosts"
Write-Host "You are running version $version of Windows PC Tuneup."
$task = Read-Host "Do you need a reboot (r) OR shutdown(s) OR keep awake(k)"
$task = $task.ToUpper()

function msdtTest {
    try {
        New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
    }
    catch {
        -ErrorAction Ignore
    }

    Set-Location -Path HKCR:\
    $keyname = "HKCR:\ms-msdt"
    if ( Get-ChildItem -Path $keyname -ErrorAction Ignore ) {
        Write-Host "it exists" -ForegroundColor Red
        Remove-Item -Recurse -Force $keyname -WhatIf
        Write-Host "MSDT is removed." -ForegroundColor Green
    }
    else {
        write-host "MSDT is already gone." -ForegroundColor Green
    }
}

function stateTogg {
    if ( $task -eq 'S' ) {
        Stop-Computer -Force
        }
    elseif ($task -eq 'R') {
        Restart-Computer -Force
        }
    else { Write-Host "Keeping awake"}
}

function gitUpdater{
    try {
        Write-Host "Updating the maintenance and security files" -ForegroundColor Yellow
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/mrcodelab/ServerAdminTinkering/main/Windows/w10_pc_tuneup.ps1 -OutFile '$HOME\Downloads'
        $zip1 = Get-FileHash -Algorithm SHA256 $HOME\Downloads\w10_pc_tuneup.ps1 | Select-Object -ExpandProperty Hash
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/mrcodelab/hashes/main/w10_pc_hash.txt -OutFile '$HOME\Downloads'
        $hash1 = Get-Content $HOME\Downloads\w10_pc_hash.txt
        if ( $zip1 -eq $hash1 ) {
            Move-Item w10_pc_tuneup.ps1 $b
            Write-Host "Tuneup file updated." -ForegroundColor Green
        }
        else { Write-Host "The tuneup hash did not match!" -ForegroundColor Red }
    }
    catch {
        Write-Host "" -ErrorAction SilentlyContinue
    }

    try {
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/mrcodelab/pihole-g/main/hosts -OutFile '$HOME\Downloads'
        $zip2 = Get-FileHash -Algorithm SHA256 $HOME\Downloads\hosts | Select-Object -ExpandProperty Hash
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/mrcodelab/pihole-g/main/hosts_hash.txt -OutFile '$HOME\Downloads'
        $hash2 = Get-Content $HOME\Downloads\hosts_hash.txt
        if ( $zip2 -eq $hash2 ) {
            Move-Item $Home\Downloads\hosts $h
            Write-Host "Hosts file updated." -ForegroundColor Green
        }
        else { Write-Host "The host hash did not match!" -ForegroundColor Red }
    }
    catch {
        Write-Host "" -ErrorAction SilentlyContinue
    }
    Write-Host "Security file update blocked by antivirus. No biggie." -ForegroundColor White

}

function updater {
    Get-WUInstall -Install -AcceptAll -AutoReboot -Hide
    Get-WUInstall -MicrosoftUpdate -Install -AcceptAll -AutoReboot -Hide
}

function dldclnr {
    $dldclnr = Read-Host "Do you want to erase everything in the downloads folder? (Yes/No)"
    $dldclnr = $dldclnr.ToUpper()
    if ( $dldclnr -eq "YES" ) {
        Remove-Item -Path $Home\Downloads\* -Recurse -Force
        Write-Host "Done cleaning downloads" -ForegroundColor Green
    }
    else {
        Write-Host "No problem, skipping this step."
        Remove-Item $HOME\Downloads\*.gz -Recurse
    }
}

function cleanup {
    Set-Location $HOME
    Clear-RecycleBin -DriveLetter C -Force -ErrorAction SilentlyContinue
    Write-Host "Recycle Bin cleaned - Ignore the error. It works." -ForegroundColor Green
    dldclnr
    Write-Host "Cleaning the temp folder." -ForegroundColor Yellow
    Remove-Item -Path C:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Temp folder cleaned." -ForegroundColor Green
    Set-Location $PSScriptRoot
    Start-Process -FilePath "C:\WINDOWS\system32\cleanmgr.exe" /sagerun:1 | Out-Null
    Wait-Process -Name 
}


function common {
    Write-Host "Testing MSDT vulnerability" -ForegroundColor Yellow
    msdtTest
    Set-Location $b
    Write-Host "Updating Windows" -ForegroundColor Yellow
    updater
    gitUpdater
    Write-Host "Windows update complete." -ForegroundColor Green
    Write-Host "Cleaning up the system bloat" -ForegroundColor Yellow
    cleanup
    Write-Host "Disk cleanup complete." - -ForegroundColor Green
    stateTogg
    Set-Location $HOME
}

Write-Host "Running common workload" -ForegroundColor Yellow

common

Stop-Process -Name powershell
