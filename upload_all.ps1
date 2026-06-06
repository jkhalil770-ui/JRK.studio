$ftpUrl = "ftp://ftpupload.net/htdocs/"
$username = "if0_41912914"
$password = "HSew7u2pBA6LRs"

# Function to recursively upload files and create directories on FTP
function Upload-Folder {
    param (
        [string]$localPath,
        [string]$remotePath
    )

    $items = Get-ChildItem -Path $localPath
    foreach ($item in $items) {
        $name = $item.Name
        
        # Skip hidden items, node_modules, upload scripts, large mp4 videos, and dev configs
        if ($name.StartsWith(".") -or $name -eq "node_modules" -or $name -eq "dist" -or $name.EndsWith(".ps1") -or $name.EndsWith(".py") -or $name.EndsWith(".mp4") -or $name -eq "package.json" -or $name -eq "package-lock.json" -or $name -eq "vite.config.js") {
            continue
        }

        $localItemPath = $item.FullName
        $remoteItemPath = if ($remotePath -eq "") { $name } else { "$remotePath/$name" }

        if ($item.PSIsContainer) {
            # It's a directory, try to create it on FTP
            $dirUrl = $ftpUrl + $remoteItemPath
            Write-Host "Creating FTP directory: $remoteItemPath ..."
            try {
                $uri = New-Object System.Uri($dirUrl)
                $ftp = [System.Net.FtpWebRequest]::Create($uri)
                $ftp.Credentials = New-Object System.Net.NetworkCredential($username, $password)
                $ftp.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
                $ftp.UsePassive = $true
                $ftp.KeepAlive = $false
                $response = $ftp.GetResponse()
                $response.Close()
            } catch {
                # Directory probably already exists, which is fine
            }
            # Recursively upload contents of this folder
            Upload-Folder -localPath $localItemPath -remotePath $remoteItemPath
        } else {
            # It's a file, upload it
            $fileUrl = $ftpUrl + $remoteItemPath
            Write-Host "Uploading $remoteItemPath ..."
            try {
                $uri = New-Object System.Uri($fileUrl)
                $ftp = [System.Net.FtpWebRequest]::Create($uri)
                $ftp.Credentials = New-Object System.Net.NetworkCredential($username, $password)
                $ftp.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
                $ftp.UsePassive = $true
                $ftp.UseBinary = $true
                $ftp.KeepAlive = $false

                $content = [System.IO.File]::ReadAllBytes($localItemPath)
                $rs = $ftp.GetRequestStream()
                $rs.Write($content, 0, $content.Length)
                $rs.Close()

                $response = $ftp.GetResponse()
                $response.Close()
                Write-Host "  Uploaded successfully!"
            } catch {
                Write-Error "  Failed to upload $remoteItemPath : $_"
            }
        }
    }
}

Upload-Folder -localPath "." -remotePath ""
Write-Host "All uploads finished."
