#$certpwd = ConvertTo-SecureString -String "123456" -Force –AsPlainText
#Import-PfxCertificate –FilePath C:\temp\livepbt_cert.pfx cert:\localMachine\my -Password $certpwd
$guid = [guid]::NewGuid()
$certHash = "5A88E626E1B7AC7E1C40ACB6908F4B91B9D12767"
$ip = "0.0.0.0" # This means all IP addresses
$Port=80
$Port_s=443
"http add sslcert ipport=$($ip):$Port_s certhash=$certHash appid={$guid}" | netsh
$HttpListener=New-Object System.Net.HttpListener
$Url=""
$prefix="http://*:$Port/$Url"
$prefix_s="https://*:$Port_s/$Url"
$HttpListener.Prefixes.add($prefix)
$HttpListener.Prefixes.add($prefix_s)
$HttpListener.Start()
#while($HttpListener.IsListening){
    $HttpContext=$HttpListener.GetContext()
    $HttpRequest=$HttpContext.Request
    $RequestUrl=$HttpRequest.Url.OriginalString
    Write-Output "$RequestUrl"
    if($HttpRequest.HasEntityBody){
        $Reader=New-Object System.IO.StreamReader($HttpRequest.InputStream)
        Write-Output $Reader.ReadToEnd()
    }
    $HttpResponse=$HttpContext.Response
    $HttpResponse.Headers.Add("content-Type","text/plain")
    $HttpResponse.StatusCode=200
    $ResponseBuffer=[System.Text.Encoding]::UTF8.GetBytes("Fuck")
    $HttpResponse.ContentLength64=$ResponseBuffer.Length
    $HttpResponse.OutputStream.Write($ResponseBuffer,0,$ResponseBuffer.Length)
    $HttpResponse.Close()
#}
$HttpListener.Stop()
"http delete sslcert ipport=$($ip):$Port_s" | netsh