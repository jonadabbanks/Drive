
#for (;;){
#script to check if file sharing is enabled 

$test = get-NetFirewallRule -DisplayGroup "File And Printer Sharing"  | Select-Object enabled

$test = $test | Where-Object { $_ -notmatch "False" } | Out-File -FilePath  C:\ProgramData\Drive\files\rj45.txt


if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\rj45.txt")){
	write-host "file sharing off"
} Else { write-host "file sharing on"
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=No}
#Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled False -Profile Any


#Enable file sharing  (paremeter will be when a file is clicked)
#netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
#}