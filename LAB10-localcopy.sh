#!/bin/bash

archivized_paths="/home/janyskali/Documents /etc/hosts"
backup="/tmp/backup"

#tworzenie plikow archiwizowanych- data musi byc co do sekundy, zeby nie
#bylo problemow z nadpisywaniem 
time=$(date +"%Y-%m-%d_%H-%M-%S:")
arch_name="backup_$time.tar.gz"
arch_path="$backup/$arch_name"

#dane do logowania
host="10.0.2.15"
user="janyskali"
password="haslo"
remotedir="/backups"

#tworzymy ten folder jesli nie istnieje
mkdir -p "$backup"

#tworzymy archiwum, c to create, z to kompresja, f to nazwa
tar -czf "$arch_path" $archivized_paths

#polaczenie ftp, i ignoruje potwierdzenia, n zeby nie logowac sie automaycznie
ftp -in "$host" <<EOF
user $user $password
cd "$remotedir"
put "$arch_path"
bye
EOF

#wyslalismy archiwum wiec je usuwamy
rm -f "$arch_path"


