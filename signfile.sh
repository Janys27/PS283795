#!/bin/bash

#musza byc 2 argumenty
if [ $# -ne 2 ]; then
    echo "Użycie: ./sign_file.sh plik tajny_klucz"
    exit 1
fi

#plik do podpisu
INPUT_FILE=$1
#klucz do wygenerowania podpisu
SECRET_KEY=$2
#plik z podpisem
SIGNATURE_FILE="${INPUT_FILE}.sig"

#generujemy podpis
SIGNATURE=$(openssl dgst -sha256 -hmac "$SECRET_KEY" "$INPUT_FILE" | awk '{print $2}')

#zapisujemy podpis do pliku
echo "$SIGNATURE" > "$SIGNATURE_FILE"

echo "Podpis zapisany do: $SIGNATURE_FILE"