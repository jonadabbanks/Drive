#for (;;){
function Block_xender {
  Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class Tricks {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@

$a = [tricks]::GetForegroundWindow()

$WH = get-process | Where-Object { $_.mainwindowhandle -eq $a }
$WH | Out-File  -FilePath C:\ProgramData\Drive\files\xender.txt
(Get-Content C:\ProgramData\Drive\files\xender.txt ) | Where-Object {$_.trim() -ne "" } | set-content C:\ProgramData\Drive\files\xender.txt
$exclude = 1,2
$gp = Get-Content C:\ProgramData\Drive\files\xender.txt | Where-Object { $_.ReadCount -NotIn $exclude }  
$gp = $gp.Trim()
$gp =$gp.Substring(54)
$gp = $gp.Trim()

Stop-Process -Name $gp
Start-Sleep -Seconds 1
}
Add-Type -AssemblyName System.Windows.Forms,System.Drawing

$screens = [Windows.Forms.Screen]::AllScreens

$top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
$left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
$width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
$height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum

$bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
$bmp      = New-Object System.Drawing.Bitmap ([int]$bounds.width), ([int]$bounds.height)
$graphics = [Drawing.Graphics]::FromImage($bmp)

$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

$bmp.Save("C:\ProgramData\Drive\files\Screen.png")

$graphics.Dispose()
$bmp.Dispose()

$text = Convert-PsoImageToText "C:\ProgramData\Drive\files\Screen.png" -Language en-us
#for Edge browser and any compartible browser
if($text -like "*:33455/'web/index.html*"-and $text -like '*Internal storage:*') 
{
  Block_xender
} else {
      Write-Host 'no'
}
if($text -like '*Xender Web*'-and $text -like '*172.20.10.1*'-and $text -like '*Internal storage:*' ) {
  Block_xender
} else {
  Write-Host 'no'
  Start-Sleep -Seconds 1
}
#}