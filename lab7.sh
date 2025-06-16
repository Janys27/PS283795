#!/bin/bash

# Sprawdzenie, czy podano tytuł filmu
if [ -z "$1" ]; then
  echo "Użycie: $0 \"Tytuł filmu\""
  exit 1
fi

API_KEY="TWÓJ_KLUCZ_API"  # <-- wpisz tutaj swój klucz API
TITLE="$1"

# Zapytanie do OMDb API (wynik w JSON)
response=$(curl -s "http://www.omdbapi.com/?apikey=${API_KEY}&t=$(echo "$TITLE" | sed 's/ /+/g')")

# Sprawdzenie, czy film został znaleziony
found=$(echo "$response" | grep -o '"Response":"True"')

if [ "$found" != '"Response":"True"' ]; then
  echo "Nie znaleziono filmu o tytule: $TITLE"
  exit 1
fi

# Wyciągnięcie podstawowych informacji za pomocą jq (jeśli masz)
# Jeśli nie masz jq, podpowiem prostą alternatywę poniżej

if command -v jq >/dev/null 2>&1; then
  echo "Tytuł: $(echo "$response" | jq -r '.Title')"
  echo "Rok: $(echo "$response" | jq -r '.Year')"
  echo "Reżyser: $(echo "$response" | jq -r '.Director')"
  echo "Ocena IMDb: $(echo "$response" | jq -r '.imdbRating')"
  echo "Opis: $(echo "$response" | jq -r '.Plot')"
else
  # Bez jq - wyciąganie info za pomocą grep i sed (mniej precyzyjne)
  echo "Tytuł: $(echo "$response" | grep -Po '(?<="Title":")[^"]*')"
  echo "Rok: $(echo "$response" | grep -Po '(?<="Year":")[^"]*')"
  echo "Reżyser: $(echo "$response" | grep -Po '(?<="Director":")[^"]*')"
  echo "Ocena IMDb: $(echo "$response" | grep -Po '(?<="imdbRating":")[^"]*')"
  echo "Opis: $(echo "$response" | grep -Po '(?<="Plot":")[^"]*')"
fi
