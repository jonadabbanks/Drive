#Register wifi devices the remaining devices will be removed from your system.
$wifi = netsh wlan show profile 
$wifi | Out-File  -FilePath C:\ProgramData\Drive\files\wifi.txt
(Get-Content C:\ProgramData\Drive\files\wifi.txt ) | Where-Object {$_.trim() -ne "" } | set-content C:\ProgramData\Drive\files\wifi.txt
$exclude = 1,2,3,4,5,6
# the scanned bluetooth devices are  trimed to get their device Id only.
$wifi = Get-Content C:\ProgramData\Drive\files\wifi.txt | Where-Object { $_.ReadCount -NotIn $exclude }  
$wifi = $wifi.Trim()
$wifi.Substring(21)


