# This forces the gpo update for the local machine

cmd.exe /c "gpupdate /force; exit"
Restart-Computer -Force