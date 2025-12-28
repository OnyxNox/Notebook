Import-Module -Force "$PSScriptRoot\lib\SetWindow.ps1"
Get-Process "mstsc" | Set-Window -X -3447 -Y 0 -Width 3454 -Height 1399
