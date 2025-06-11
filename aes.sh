#!/bin/bash

#musza byc 2 argumenty
if [ $# -ne 2 ]; then
    echo "Użycie: ./encrypt_aes.sh plik hasło"
    exit 1
fi

#plik do zaszyfrowania
INPUT_FILE=$1
#haslo uzywane do szyfrowania
PASSWORD=$2
#tworzymy plik, w ktorym bedzie zaszyfrowana zawartosc
OUTPUT_FILE="${INPUT_FILE}.aes"

#szyfrujemy plik
openssl enc -aes-256-cbc -salt -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass pass:"$PASSWORD"

echo "Plik został zaszyfrowany jako: $OUTPUT_FILE"
