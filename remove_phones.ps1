$ErrorActionPreference = 'SilentlyContinue'
$file = Get-Content -Path  C:\ProgramData\Drive\files\NULL.txt
$file | Out-File -FilePath C:\ProgramData\Drive\files\FLOW.txt

#CODES TO GET WPD DEVICES FOR PHONES (trying to fix the error of  no wpd devices
$phones = Get-PnpDevice -class 'wpd' -presentonly -ErrorAction SilentlyContinue | 
Select-Object -Property InstanceId|
Select-Object -First 2000000 | 
Out-File -FilePath "C:\ProgramData\Drive\files\MOBILE_PHONES.txt"
(Get-Content  C:\ProgramData\Drive\files\MOBILE_PHONES.txt ) | Where-Object {$_.trim() -ne "" } | set-content  C:\ProgramData\Drive\files\MOBILE_PHONES.txt
$exclude = 1,2
$phones = Get-Content "C:\ProgramData\Drive\files\MOBILE_PHONES.txt" | Where-Object { $_.ReadCount -NotIn $exclude }
$smart_phones = $phones| Where-Object { $_ -notmatch "SWD" }
$smart_phones | Out-File -FilePath "C:\ProgramData\Drive\files\MOBILE_PHONES.txt"
#add the filterd id from diff
$files = Get-Content -Path  C:\ProgramData\Drive\files\REGISTERED_MOBILE_PHONE.txt
$difff = Get-Content -Path  C:\ProgramData\Drive\files\MOBILE_PHONES.txt | Where-Object {$_ -notin $files} 
$difff | Out-File -FilePath C:\ProgramData\Drive\files\SCANNED_PHONES.txt 
 #added a text file to merge both ui control for phones and drives
 $difff | Out-File -FilePath C:\ProgramData\Drive\files\UI.txt 
Start-Sleep -Seconds 1

if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\SCANNED_PHONES.txt")){ 
  $null = Get-Content -Path  C:\ProgramData\Drive\files\NULL.txt
  $null | Out-File -FilePath C:\ProgramData\Drive\files\pmounted.txt

  }Else{
   #This part of the script filters the spaces from phones 
  $pd = Get-Content C:\ProgramData\Drive\files\SCANNED_PHONES.txt
  $pd = $pd  -replace " ",""
  #this code tells the program to leave temp authorised phones.
  $pmounted = Get-Content -Path  C:\ProgramData\Drive\files\pmounted.txt
  $pnotmounted = $pd | Where-Object {$_ -notin $pmounted} 
  $pnotmounted | Out-File -FilePath  C:\ProgramData\Drive\files\pnotmounted.txt
  if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\pnotmounted.txt")){ 
  }Else{
  #this scrip removes the unregistered phones using its instance id 
  foreach-object {		
  Disable-PnpDevice  -InstanceId $pnotmounted -Confirm:$false -ErrorAction SilentlyContinue}
  #this script alerts the ui to pop out an insert password gui.
  "ALERT" | Out-File -FilePath  C:\ProgramData\Drive\files\hotkey.txt
  
  if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\online.txt")){
    }Else{
  foreach-object {		
  Enable-PnpDevice  -InstanceId $pnotmounted -Confirm:$false  -Ev Err -EA SilentlyContinue}
  #this saves the temp phones allowed not to be removed when the cycle begins again 
  $pd | Out-File -FilePath  C:\ProgramData\Drive\files\pmounted.txt
  Add-Content C:\ProgramData\Drive\files\pmounted.txt $pd
  #this reloads the enable drive zone to be used again 
  $file = Get-Content -Path  C:\ProgramData\Drive\files\NULL.txt
  $file | Out-File -FilePath C:\ProgramData\Drive\files\online.txt
}
}
}
