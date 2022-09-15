<# still in development

#script to check if file sharing is enabled 
for (;;){
$test = get-NetFirewallRule -DisplayGroup "File And Printer Sharing"  |Select-Object enabled

$test = $test | Where-Object { $_ -notmatch "False" } | Out-File -FilePath  C:\ProgramData\Drive\files\rj45.txt


if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\rj45.txt")){
	write-host "file sharing off"
} Else { write-host "file sharing on"
#disable file sharing 
  if ( [bool](get-job -Name MyTask -ea silentlycontinue) ){

	Write-host "still disabling"
 }Else {
$disable  ={Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled False -Profile Any}
Start-Job $disable -name MyTask }

}
}
#run as a job (because it takes too much time )



#Enable file sharing 
#Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled True -Profile Any

#>