import ftplib

try:
    ftp = ftplib.FTP('ftpupload.net', 'if0_41912914', 'HSew7u2pBA6LRs')
    ftp.cwd('htdocs')
    with open('.htaccess', 'rb') as f:
        ftp.storbinary('STOR .htaccess', f)
    with open('index.html', 'rb') as f:
        ftp.storbinary('STOR index.html', f)
    with open('robots.txt', 'rb') as f:
        ftp.storbinary('STOR robots.txt', f)
    with open('sitemap.xml', 'rb') as f:
        ftp.storbinary('STOR sitemap.xml', f)
    ftp.quit()
    print("Uploaded .htaccess, index.html, robots.txt, and sitemap.xml")
except Exception as e:
    print("Error:", e)
