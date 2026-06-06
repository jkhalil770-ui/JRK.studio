$ftpUrl = "ftp://ftpupload.net/htdocs/"
$username = "if0_41912914"
$password = "HSew7u2pBA6LRs"

$files = @(
    "robots.txt",
    "sitemap.xml",
    ".htaccess"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        $uri = New-Object System.Uri($ftpUrl + $file)
        $ftp = [System.Net.FtpWebRequest]::Create($uri)
        $ftp.Credentials = New-Object System.Net.NetworkCredential($username, $password)
        $ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
        $ftp.UsePassive = $true
        $ftp.UseBinary = $true
        $ftp.KeepAlive = $false

        Write-Host "Uploading $file..."
        $content = [System.IO.File]::ReadAllBytes((Resolve-Path $file).Path)
        $rs = $ftp.GetRequestStream()
        $rs.Write($content, 0, $content.Length)
        $rs.Close()
        
        $response = $ftp.GetResponse()
        Write-Host "  Success: $($response.StatusDescription)"
        $response.Close()
    } else {
        Write-Host "File $file not found locally."
    }
}
Write-Host "All uploads finished."
