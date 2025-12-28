$WShell = New-Object -Com "Wscript.Shell"
while ($true) { $WShell.SendKeys("{SCROLLLOCK}"); Start-Sleep 1; $WShell.SendKeys("{SCROLLLOCK}"); Start-Sleep 180; }