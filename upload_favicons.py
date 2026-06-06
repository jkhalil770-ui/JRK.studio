import ftplib

files_to_upload = [
    'index.html',
    'site.webmanifest',
    'favicon-16x16.png',
    'favicon-32x32.png',
    'favicon.svg',
    'apple-touch-icon.png',
    'android-chrome-192x192.png',
    'android-chrome-512x512.png'
]

try:
    print("Connecting to FTP...")
    ftp = ftplib.FTP('ftpupload.net', 'if0_41912914', 'HSew7u2pBA6LRs')
    ftp.cwd('htdocs')
    print("Connected! Uploading files...")
    
    for filename in files_to_upload:
        try:
            with open(filename, 'rb') as f:
                ftp.storbinary(f'STOR {filename}', f)
            print(f"  [+] Uploaded: {filename}")
        except Exception as e:
            print(f"  [-] Failed to upload {filename}: {e}")
            
    ftp.quit()
    print("All done!")
except Exception as e:
    print("FTP Connection Error:", e)
