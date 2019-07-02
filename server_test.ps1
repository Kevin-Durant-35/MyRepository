$Connection=New-Object System.Net.Sockets.TcpListener("127.0.0.1",5000)
$Connection.Start()
$Client=$Connection.AcceptTcpClient()
$Stream=$Client.GetStream()
$Stream.ReadTimeout=5000
$Stream.WriteTimeout=5000
$sslStream=New-Object System.Net.Security.SslStream($Stream,$false,([Net.ServicePointManager]::ServerCertificateValidationCallback={$true}))
$Path=Split-Path $MyInvocation.MyCommand.Definition
$Cert_Path=$Path+"\server.crt"
$serverCertificate=[System.Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromCertFile($Cert_Path)
$sslStream.AuthenticateAsServer($serverCertificate,$false,[Net.SecurityProtocolType]::Ssl3,$true)
[byte[]]$buffer=$sslStream.ReadByte()
[byte[]]$message =[System.Text.Encoding]::UTF8.GetBytes("Hello from the server.<EOF>")
$sslStream.WriteByte($message)
$Connection.Stop()

#Exception calling "AuthenticateAsServer" with "4" argument(s): The server mode SSL must use a certificate with the associated private key
#$sslStream.AuthenticateAsServer($serverCertificate,$false,[Net.SecurityProtocolType]::Ssl3,$true)
#The certification file is genarated by OpenSSL in Ubuntu