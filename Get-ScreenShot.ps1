Function Get-ScreenShot{
    [CmdletBinding()] Param(
        [Parameter(Mandatory=$True)]             
        [ValidateScript({Test-Path -Path $_ })]
        [String] $Path, 

        [Parameter(Mandatory=$True)]             
        [Int32] $Interval,

        [Parameter(Mandatory=$True)]             
        [Int32] $Times    
    )
$Code={
    Param (
       [Parameter(Position = 0)]
       [Int]$Times,
       [Parameter(Position = 1)]
       [Int]$Interval,
       [Parameter(Position = 2)]
       [String] $Path
    )
    do{
        $Time = (Get-Date)
        [String] $FileName = "$($Time.Month)"
        $FileName += '-'
        $FileName += "$($Time.Day)" 
        $FileName += '-'
        $FileName += "$($Time.Year)"
        $FileName += '-'
        $FileName += "$($Time.Hour)"
        $FileName += '-'
        $FileName += "$($Time.Minute)"
        $FileName += '-'
        $FileName += "$($Time.Second)"
        $FileName += '.png'

        [String]$FilePath =  $FileName
       $ScreenBounds = [Windows.Forms.SystemInformation]::VirtualScreen

       $VideoController = Get-WmiObject -Query 'SELECT VideoModeDescription FROM Win32_VideoController'

       if ($VideoController.VideoModeDescription -and $VideoController.VideoModeDescription -match '(?<ScreenWidth>^\d+) x (?<ScreenHeight>\d+) x .*$') {
           $Width = [Int] $Matches['ScreenWidth']
           $Height = [Int] $Matches['ScreenHeight']
       } else {
           $ScreenBounds = [Windows.Forms.SystemInformation]::VirtualScreen

           $Width = $ScreenBounds.Width
           $Height = $ScreenBounds.Height
       }

       $Size = New-Object System.Drawing.Size($Width, $Height)
       $Point = New-Object System.Drawing.Point(0, 0)

       $ScreenshotObject = New-Object Drawing.Bitmap $Width, $Height
       $DrawingGraphics = [Drawing.Graphics]::FromImage($ScreenshotObject)
       $DrawingGraphics.CopyFromScreen($Point, [Drawing.Point]::Empty, $Size)
       $DrawingGraphics.Dispose()
       [String]$FilePath = (Join-Path $Path $FileName)
       $ScreenshotObject.Save($FilePath)
       $ScreenshotObject.Dispose()
        Start-Sleep -Seconds $Interval
        $Times=$Times-1
    }while($Times -ge 1)
}
$PowerShell = [PowerShell]::Create()
[void]$PowerShell.AddScript($Code)
[void]$PowerShell.AddArgument($Times)
[void]$PowerShell.AddArgument($Interval)
[void]$PowerShell.AddArgument($Path)
[void]$PowerShell.BeginInvoke()
}