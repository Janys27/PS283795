#!/bin/bash

#parameters
#$1-name
#$2-server
#$3-password

#file with outputs
textfile="log.txt"


#log in using a password and a login, provide the server, list the processes and display their properties, then save them in a textfile

sshpass -p "$3" ssh -o StrictHostKeyChecking=no "$1@$2" "ls -l; ps aux" > "$textfile"



