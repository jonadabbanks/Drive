for (;;){  
     #REMOVE DRIVES
     
         $ErrorActionPreference = 'SilentlyContinue'
     
         $test = Get-Process -Name drive -ErrorAction SilentlyContinue
     
         $test | Out-File -FilePath  C:\ProgramData\Drive\files\drive_process.txt
         if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\drive_process.txt")){
         
             Invoke-Item C:\ProgramData\Drive\Files\drive.exe
         }
     
     
         # This part of the script gets only plugged in usb devices 
         Get-WmiObject Win32_USBControllerDevice |ForEach-Object{[wmi]($_.Dependent)} | Where-Object {($_.Description -like '*mass*')} | Sort-Object Description, pnpclass,DeviceID | Format-Table DeviceID  -auto | Format-Table -AutoSize | Out-File -FilePath C:\ProgramData\Drive\files\GET_DISK.txt 
         (Get-Content C:\ProgramData\Drive\files\GET_DISK.txt ) | Where-Object {$_.trim() -ne "" } | set-content C:\ProgramData\Drive\files\GET_DISK.txt
         $exclude = 1,2	
        
         $drives = Get-Content "C:\ProgramData\Drive\files\GET_DISK.txt" | Where-Object { $_.ReadCount -NotIn $exclude }
         $drives | Out-File -FilePath C:\ProgramData\Drive\files\GET_DISK.txt
         Start-Sleep -Seconds 1.5
         
         # This part of the script compares the newly scanned drives with the registered ones, and isolate the unregistered ones 
         $registered = Get-Content -Path  C:\ProgramData\Drive\files\REGISTERED_DRIVE.txt
          $registered = $registered.Substring(0,43)
          $registered = $registered.Trim()
         $unregistered = Get-Content -Path  C:\ProgramData\Drive\files\GET_DISK.txt | Where-Object {$_ -notin $registered} 
         $unregistered | Out-File -FilePath C:\ProgramData\Drive\files\Unauthorized.txt 
     
     
     
         #added a text file to merge both ui control for phones and drives to be in 1 file
         $unregistered | Out-File -FilePath C:\ProgramData\Drive\files\UI.txt 
        
     
        # this section removes all temp saved drives, when the drives are removed from the system
         if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\Unauthorized.txt")){ 
         $null = Get-Content -Path  C:\ProgramData\Drive\files\NULL.txt
         $null | Out-File -FilePath C:\ProgramData\Drive\files\mounted.txt
         }Else{
     
        #this code tells the program to leave temp authorised drives. by comparing it with the ones already allowed inside to work
         $id = Get-Content C:\ProgramData\Drive\files\Unauthorized.txt
         $id = $id.trim()
         $mounted = Get-Content -Path  C:\ProgramData\Drive\files\mounted.txt
         $notmounted = $id | Where-Object {$_ -notin $mounted} 
         $notmounted | Out-File -FilePath  C:\ProgramData\Drive\files\notmounted.txt
     
     
     
         #region of drive removal 
         if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\notmounted.txt")){ 
         }Else{
     
         #alerts the ui to pop out password
         "ALERT" | Out-File -FilePath  C:\ProgramData\Drive\files\hotkey.txt
         foreach-object {		
           #this scrip removes the unregistered drives using its instance id 
         Disable-PnpDevice  -InstanceId $notmounted -Confirm:$false -ErrorAction SilentlyContinue}
       
         #this script alerts the ui to pop out an insert password gui.
         
         $online = Get-item "C:\ProgramData\Drive\Files\online.txt"
         #region of drives recovery
         if ($Null -eq ($online)){
         foreach-object {		
         $notmounted = Get-Content -Path   C:\ProgramData\Drive\files\notmounted.txt 
         Enable-PnpDevice  -InstanceId $notmounted -Confirm:$false  -Ev Err -EA SilentlyContinue}
         
         #this saves the temp drive, and  prevent if from being removed when the cycle begins again 
         Add-Content C:\ProgramData\Drive\files\mounted.txt $notmounted
         #this reloads the enable drive zone to be used again 
         $file = Get-Content -Path  C:\ProgramData\Drive\files\NULL.txt
         $file | Out-File -FilePath C:\ProgramData\Drive\files\online.txt
        
       }
       }
       
       }
       Start-Sleep -Seconds 1.5
       #REMOVE PHONES
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
       
       $online = Get-item "C:\ProgramData\Drive\Files\online.txt"
     
       if ($Null -eq ($online)){
       write-host "no file"
       foreach-object {		
       Enable-PnpDevice  -InstanceId $pnotmounted -Confirm:$false  -Ev Err -EA SilentlyContinue}
     
       #this saves the temp phones allowed not to be removed when the cycle begins again 
       $pd | Out-File -FilePath  C:\ProgramData\Drive\files\pmounted.txt
       Add-Content C:\ProgramData\Drive\files\pmounted.txt $pd
       #this reloads the enable drive zone to be used again 
       $file = Get-Content -Path  C:\ProgramData\Drive\files\NULL.txt
       $file | Out-File -FilePath C:\ProgramData\Drive\files\online.txt
       #remove_item  C:\ProgramData\Drive\files\hotkey.txt
     }Else{Write-Host "file inside"}
     }
       
     }
     
     
     #BLOCK NETWORK
     #to be added a file paremeter to decide if it will run or not 
     
     #script to check if file sharing is enabled
     $test = get-NetFirewallRule -DisplayGroup "File And Printer Sharing"  | Select-Object enabled
     Start-Sleep -Seconds 1.5
     $test = $test | Where-Object { $_ -notmatch "False" } | Out-File -FilePath  C:\ProgramData\Drive\files\rj45.txt
     
     
     if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\rj45.txt")){
     } Else { 
     netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=No
     netsh advfirewall firewall set rule group= "network discovery" new enable = no}
     
     
     #Set-NetFirewallRule -DisplayGroup "File And Printer Sharing" -Enabled False -Profile Any
     
     
     #Enable file sharing  (paremeter will be when a file is clicked)
     #netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
     
     
     
     
     #XENDER BLOCKING 
     #to be added a file paremeter to decide if it will run or not 
     $ErrorActionPreference = 'SilentlyContinue'
     $tcp  = netstat -ano |findstr :33455 
     $tcp = $tcp.substring(68)
     $tcp = $tcp.trim()
     foreach ($i in $tcp) {
     Stop-Process -ID $i -Force}
     
     
     
     
     #Bluetooth  block
     #to be added a file paremeter to decide if it will run or not 
     
     $test = Get-Process -Name drive -ErrorAction SilentlyContinue
     $test | Out-File -FilePath  C:\ProgramData\Drive\files\fsquirt.txt
     if ($Null -eq (Get-Content -Path  "C:\ProgramData\Drive\files\fsquirt.txt")){
     }else{stop-process -Name fsquirt}
     
     
     }