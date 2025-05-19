#!/bin/bash

#files well be working with
logfile="/var/log/auth.log"
reportfile="sus_report.txt"

#generate date
echo "Data: $(date)" >> "$reportfile"

#newline
echo "" >> "$reportfile"

echo "failed login attempts:" >> "$reportfile"
grep "invalid user"  "$logfile" | awk '{print $1, $2, $3, $8, $10}' >> "$reportfile"
# $1, $2, $3- date, $8-username $10- ip address

echo "done"
