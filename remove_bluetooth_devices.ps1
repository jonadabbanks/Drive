function Unpair_Bluetooth{

    # take a UInt64 either directly or as part of an object with a property
    # named "DeviceAddress" or "Address"
    param
    (
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias('Address')]
        [UInt64]
        $DeviceAddress
    )

    # tell PowerShell the location of the internal Windows API
    # and define a static helper function named "Unpair" that takes care
    # of creating the needed arguments:
    begin
    {
        Add-Type -Namespace "Devices" -Name 'Bluetooth' -MemberDefinition '
[DllImport("BluetoothAPIs.dll", SetLastError = true, CallingConvention = CallingConvention.StdCall)]
[return: MarshalAs(UnmanagedType.U4)]
static extern UInt32 BluetoothRemoveDevice(IntPtr pAddress);
public static UInt32 Unpair(UInt64 BTAddress) {
    GCHandle pinnedAddr = GCHandle.Alloc(BTAddress, GCHandleType.Pinned);
    IntPtr pAddress     = pinnedAddr.AddrOfPinnedObject();
    UInt32 result       = BluetoothRemoveDevice(pAddress);
    pinnedAddr.Free();
    return result;
}'
    }

    # do this for every object that was piped into this function:
    process
    {
        $result = [Devices.Bluetooth]::Unpair($DeviceAddress)
        [PSCustomObject]@{
            Success = $result -eq 0
            ReturnValue = $result
        }
    }
}


$Address =     @{
    Name='Address'
Expression={$_.HardwareID | 
ForEach-Object { [uInt64]('0x' + $_.Substring(12))}}
}
Get-PnpDevice -Class Bluetooth |
    Where-Object HardwareID -match 'DEV_' |
    Select-Object FriendlyName,Status,$Address |
    Where-Object Address | Out-File -FilePath C:\ProgramData\Drive\files\NBT.txt
	(Get-Content C:\ProgramData\Drive\files\NBT.txt ) | Where-Object {$_.trim() -ne "" } | set-content C:\ProgramData\Drive\files\NBT.txt
  $exclude = 1,2 
  # the scanned bluetooth devices are  trimed to get their device Id only.
  $ns = Get-Content C:\ProgramData\Drive\files\NBT.txt | Where-Object { $_.ReadCount -NotIn $exclude }  
  $ns = $ns.Substring(28)
  $ns = $ns.trim()
  $ns | Out-File -FilePath C:\ProgramData\Drive\files\NBT.txt 
  # this part of the script isolates the device Id from the saved bluetooth devices
  $bt = Get-Content -Path  C:\ProgramData\Drive\files\SAVED_BLUETOOTH.txt
  $bt = $bt.Substring(28)
  $bt = $bt.trim()
# both bluetooth address from both saved and newly scanned drives are checked for differences. 
# the differences is then isolated as the unregistered drive and is passed down to be removed.

  $diff = Get-Content -Path  C:\ProgramData\Drive\files\NBT.txt | Where-Object {$_ -notin $bt} 
  $diff | Unpair_Bluetooth
  #script continues when called from the file again.
  
 