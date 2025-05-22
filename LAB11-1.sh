#!/bin/bash

plik="$1"

#uzywamy exiftoola i podajemy mu to co chcemy- czyli informacje geolokalizacyjne
exiftool -GPSLatitude -GPSLongitude -GPSAltitude -GPSPosition "$plik"
