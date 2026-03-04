#!/bin/bash

sed -i 's/nameserver 127.0.0.53/nameserver 172.16.4.4/g' file.txt
sed -i 's/search entdef.home.arpa/search cachemeoutside.lab/g' file.txt
sed -i '/^options edns0 trust-ad$/d' file.txt

realm discover cachemeoutside.lab

echo "Drift-Affront3" | realm join -U Administrator cachemeoutside.lab


sed -i 's/nameserver 172.16.4.4/nameserver 127.0.0.53/g' file.txt
sed -i 's/search cachemeoutside.lab/search entdef.home.arpa/g' file.txt
echo "options edns0 trust-ad" >> file.txt

sleep 3

ping -c 3 google.com 
