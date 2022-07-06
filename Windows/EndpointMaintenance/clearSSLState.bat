@REM This will theoretically call a pair of undocumented rundll commands as command line

cmd.exe /c "rundll32.exe inetcpl.cpl,ClearMyTracksByProcess 2234; exit"