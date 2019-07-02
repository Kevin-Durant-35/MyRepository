$SrcUrl=""
$Number = 207
$content=Invoke-WebRequest -Uri $SrcUrl
$Url=$content.Images[0].src
$CurrentPath = $MyInvocation.MyCommand.Definition
$CurrentPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$NewPath = $CurrentPath+'\'+$content.Images[0].alt.Split(':')[-1]
#$NewPath = $CurrentPath+'\'+"New"
$NewPath
New-Item -Path $NewPath -ItemType Directory -Force
$index = 183
while ($index -le $Number)
{
    $PicName="bz"+$index+".jpg"
    $Next_Url=$Url.Replace("bz1.jpg",$PicName)
    write-host $Next_Url -NoNewline 
    $Destnation =  $NewPath+'\'+$index+'.jpg'
    Invoke-WebRequest -Uri $Next_Url -OutFile $Destnation -UseBasicParsing
    $index++
    write-host " Done!"
 }