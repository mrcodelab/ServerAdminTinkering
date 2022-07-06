$pagefileout = "$HOME\Downloads\pagefilesize.txt"
$memsize = Get-CimInstance -Class CIM_PhysicalMemory | Select-Object -ExpandProperty Capacity
$pfile = Get-CimInstance -Class Win32_PageFileUsage -ComputerName $Computer | Select-Object -ExpandProperty PeakUsage
$pconvert = ($pfile * 1024000)

function reading($bytecount) {
    switch ([math]::truncate([math]::log($bytecount,1024))) {
        
        '0' { "$bytecount Bytes" }
        '1' { "{0:n2} KB" -f ($bytecount / 1KB) }
        '2' { "{0:n2} MB" -f ($bytecount / 1MB) }
        '3' { "{0:n2} GB" -f ($bytecount / 1GB) }
        '4' { "{0:n2} TB" -f ($bytecount / 1TB) }
        Default { "{0:n2} PB" -f ($bytecount / 1pb) }
    }    
}
Write-Output "Peak PageFile size since last reboot is: $(reading($pconvert))" | Out-File $pagefileout

$installed = reading($memsize)
Write-Output "$installed are installed" | Out-File -Append $pagefileout
if ($memsize -gt 1224000000) {
    Write-Output "You really shouldn't need more than about 8Gb of swap.
Please contact an administrator if your system is experiencing performance issues under normal load.
____________________________________________________________________________________________________
" | Out-File -Append $pagefileout
}
$minpage = reading($memsize * 1.5)
$maxpage = reading(($memsize * 1.5) * 3)
Write-Output "Your page file size estimate is between $minpage and $maxpage." | Out-File -Append $pagefileout