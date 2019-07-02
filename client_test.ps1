$bGet=-1
[byte[]]$message =[System.Text.Encoding]::UTF8.GetBytes("Hello,this is from the client.<EOF>")
$Connection=New-Object System.Net.Sockets.TcpClient("127.0.0.1",5000)
$Connection.SendTimeout=5000
$Connection.ReceiveTimeout=5000
$Stream=$Connection.GetStream()
$sslStream=New-Object System.Net.Security.SslStream($Stream,$false,([Net.ServicePointManager]::ServerCertificateValidationCallback={$true}))
$sslStream.AuthenticateAsClient($null)
$sslStream.Write($message,0,$message.Count)
$sslStream.Flush()
$buffer=New-Object byte[] 16
do{
    $bGet=$sslStream.Read($buffer,0,16)
    [string]$s=[System.Text.Encoding]::UTF8.GetString($buffer)
    if($s.IndexOf("<EOF>") -ne -1){break}
}while($bGet -ne 0)
$buffer
$Connection.Close()