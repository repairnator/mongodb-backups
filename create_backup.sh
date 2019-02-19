#!/bin/bash

# A simple script to automatically fetch the database, compress it maximally and push it to github.

MONGO_IP= #The ip-address of the mongodb
MONGO_PORT= #The port that the mongodb is listening on
MONGO_USER= #The username to the mongodb
MONGO_PASS= #The password to the mongodb
MONGO_AUTH= #The database to authenticate to
DATE_SLASH="$(date -d now +%x)"
DATE="${DATE_SLASH//\//.}"

mongodump --host "$MONGO_IP:$MONGO_PORT" -u "$MONGO_USER" -p "$MONGO_PASS" --authenticationDatabase "$MONGO_AUTH" --out "$DATE"
wait

7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on "$DATE".7z "$DATE"

# This runs from the directory right above the git-folder

cd mongodb-backups/

mv "../$DATE.7z" ./
git add "$DATE.7z"
git commit -m "Adds backup of the mongodb from $DATE"
git push
cd ..
rm -r "$DATE"
