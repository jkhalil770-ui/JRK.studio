import ftplib
import os
import time

def connect():
    ftp = ftplib.FTP('ftpupload.net', 'if0_41912914', 'HSew7u2pBA6LRs')
    ftp.cwd('htdocs')
    return ftp

session = connect()

def upload_dir(path):
    global session
    for item in os.listdir(path):
        if item.startswith('.') or item == 'node_modules' or item == 'upload.py':
            continue
        local_path = os.path.join(path, item)
        if os.path.isfile(local_path):
            try:
                # try to skip if exists
                if item in session.nlst():
                    print(f"Skipping {local_path}")
                    continue
            except Exception:
                pass

            print(f"Uploading {local_path}")
            try:
                with open(local_path, 'rb') as file:
                    session.storbinary(f'STOR {item}', file)
            except Exception as e:
                print(f"Error {e}, reconnecting...")
                try: session.quit()
                except: pass
                time.sleep(2)
                session = connect()
                
        elif os.path.isdir(local_path):
            try:
                session.mkd(item)
            except ftplib.error_perm:
                pass
            session.cwd(item)
            upload_dir(local_path)
            session.cwd('..')

try:
    upload_dir('.')
except Exception as e:
    pass
finally:
    try: session.quit()
    except: pass
print("Done")
