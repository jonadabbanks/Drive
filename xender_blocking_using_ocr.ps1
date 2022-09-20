# make sure all required assemblies are loaded BEFORE any class definitions use them:
try
{
  Add-Type -AssemblyName System.Runtime.WindowsRuntime
    
  # WinRT assemblies are loaded indirectly:
  $null = [Windows.Storage.StorageFile,                Windows.Storage,         ContentType = WindowsRuntime]
  $null = [Windows.Media.Ocr.OcrEngine,                Windows.Foundation,      ContentType = WindowsRuntime]
  $null = [Windows.Foundation.IAsyncOperation`1,       Windows.Foundation,      ContentType = WindowsRuntime]
  $null = [Windows.Graphics.Imaging.SoftwareBitmap,    Windows.Foundation,      ContentType = WindowsRuntime]
  $null = [Windows.Storage.Streams.RandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]
  $null = [WindowsRuntimeSystemExtensions]
    
  # some WinRT assemblies such as [Windows.Globalization.Language] are loaded indirectly by returning
  # the object types:
  $null = [Windows.Media.Ocr.OcrEngine]::AvailableRecognizerLanguages

  # grab the async awaiter method:
  Add-Type -AssemblyName System.Runtime.WindowsRuntime
  # find the awaiter method
  $awaiter = [WindowsRuntimeSystemExtensions].GetMember('GetAwaiter', 'Method',  'Public,Static') |
  Where-Object { $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' } |
  Select-Object -First 1

  # define awaiter function
  function Invoke-Async([object]$AsyncTask, [Type]$As)
  {
    return $awaiter.
    MakeGenericMethod($As).
    Invoke($null, @($AsyncTask)).
    GetResult()
  }
}
catch
{
  throw 'OCR requires Windows 10 and Windows PowerShell. You cannot use this module in PowerShell 7'
}

function Convert-PsoImageToText
{
  <#
      .SYNOPSIS
      Converts an image file to text by using Windows 10 built-in OCR
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Convert-ImageToText -Path c:\temp\image.png
      Converts the image in image.png to text
      
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]
    [Alias('FullName')]
    $Path,
    
    # dynamically create auto-completion from available OCR languages:
    [ArgumentCompleter({
          # receive information about current state:
          param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
          [Windows.Media.Ocr.OcrEngine]::AvailableRecognizerLanguages |
          Foreach-Object { 
            # create completionresult items:
            $displayname = $_.DisplayName
            $id = $_.LanguageTag
            [System.Management.Automation.CompletionResult]::new($id, $displayname, "ParameterValue", "$displayName`r`n$id")
          }
            })]
    [Windows.Globalization.Language]
    $Language
  )
  
  begin
  { 
    Add-Type -AssemblyName System.Runtime.WindowsRuntime
     
    # [Windows.Media.Ocr.OcrEngine]::AvailableRecognizerLanguages
    if ($PSBoundParameters.ContainsKey('Language'))
    {
      $ocrEngine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromLanguage($Language)
    }
    else
    {
      $ocrEngine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    }
  
    
    # PowerShell doesn't have built-in support for Async operations, 
    # but all the WinRT methods are Async.
    # This function wraps a way to call those methods, and wait for their results.
    
  }
  
  process
  {
    # all of these methods run asynchronously because they are tailored for responsive UIs
    # PowerShell is single-threaded and synchronous so a helper function is used to 
    # run the async methods and wait for them to complete, essentially reversing the async 
    # behavior
    
    # Invoke() requires the async method and the desired return type
  
    # get image file:
    $file = [Windows.Storage.StorageFile]::GetFileFromPathAsync($path)
    $storageFile = Invoke-Async $file -As ([Windows.Storage.StorageFile])
  
    # read image content:
    $content = $storageFile.OpenAsync([Windows.Storage.FileAccessMode]::Read)
    $fileStream = Invoke-Async $content -As ([Windows.Storage.Streams.IRandomAccessStream])
  
    # get bitmap decoder:
    $decoder = [Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($fileStream)
    $bitmapDecoder = Invoke-Async $decoder -As ([Windows.Graphics.Imaging.BitmapDecoder])
  
    # decode bitmap:
    $bitmap = $bitmapDecoder.GetSoftwareBitmapAsync()
    $softwareBitmap = Invoke-Async $bitmap -As ([Windows.Graphics.Imaging.SoftwareBitmap])
  
    # do optical text recognition (OCR) and return lines and words:
    $ocrResult = $ocrEngine.RecognizeAsync($softwareBitmap)
    (Invoke-Async $ocrResult -As ([Windows.Media.Ocr.OcrResult])).Lines | 
      Select-Object -Property Text, @{Name='Words';Expression={$_.Words.Text}}
  }
}






for (;;){
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
}
  if($text -like '*Specify the location of your website*'-and $text -like '*Internet or network address*'-and $text -like '*FTP*' ) {
    Stop-Process -Name rundll32
  } else {
    Write-Host 'no'
  Start-Sleep -Seconds 1
}
}