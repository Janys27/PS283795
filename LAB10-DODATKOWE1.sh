#!/bin/bash

#parametry wymagane przez ftp
server="10.0.2.15"
user="janyskali"
pass="haslo"
rem_dir="/home/janyskali/backups"
loc_dir="/home/janyskali/laby10"

#tworzymy  biblioteke jesli jej nie ma (oczywiscie jest, bo w to w niej jest plik)
mkdir -p "$loc_dir"
#tworzymy plik z logami z danego dnia
file="$loc_dir/ftplog$(date +%F).log"

#ftp, przesylamy bledy wraz do logow
ftp -inv "$server" <<EOF > "$file" 2>&1
user $user $pass
cd $rem_dir
#zmieniamy folder by zapisywac w locdir
lcd $loc_dir
#pobieramy wszystkie pliki (mozna ustawic jakis wzorzec)
mget *
bye
EOF

echo "zakonczono $(date)" >> "$file"
