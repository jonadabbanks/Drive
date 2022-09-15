# The script below, will be used to scan  saved bluetooth devices on a windows machine 

$Address =     @{
    Name='Address'
Expression={$_.HardwareID | 
ForEach-Object { [uInt64]('0x' + $_.Substring(12))}}
}



Get-PnpDevice -Class Bluetooth |
Where-Object HardwareID -match 'DEV_' |
Select-Object FriendlyName, status,$Address |
Where-Object Address | Out-File -FilePath C:\ProgramData\Drive\files\TSBT.txt
#Start-Sleep -Seconds 1
(Get-Content C:\ProgramData\Drive\files\TSBT.txt ) | Where-Object {$_.trim() -ne "" } | set-content C:\ProgramData\Drive\files\TSBT.txt
$exclude = 1,2 
$bt = Get-Content "C:\ProgramData\Drive\files\TSBT.txt" | Where-Object { $_.ReadCount -NotIn $exclude }
$bt | Out-File -FilePath C:\ProgramData\Drive\files\TSBT.txt
$bt
#All saved bluetooth devices in the system will be outputed to the Gui for the end user to select which to register 


# REgion of Registration  (via Gui)

# Selected bluetooth devicces will be added to a text file 
Add-Content C:\ProgramData\Drive\files\SAVED_BLUETOOTH.txt "`r%Selectedbt%"
(Get-Content C:\ProgramData\Drive\files\SAVED_BLUETOOTH.txt ) | Where-Object {$_.trim() -ne "" } | set-content C:\ProgramData\Drive\files\SAVED_BLUETOOTH.txt

$File = Get-Content -Path "C:\ProgramData\Drive\files\SAVED_BLUETOOTH.txt"

#Selected bluetooth devices will be filtered to makke sure there are no conflicting devices or more than one devices 
$Existing = New-Object -TypeName System.Collections.ArrayList

$Unique = foreach( $Line in $File ){
    if( $Existing -contains $Line ){
        continue
        }

    $null = $Existing.Add( $Line )

    $Line
    }

$Unique | Out-File -FilePath C:\ProgramData\Drive\files\SAVED_BLUETOOTH.txt

Exit
