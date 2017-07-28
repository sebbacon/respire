#!/bin/bash
set -e
git pull
touch tmp/restart.txt
rsync -Cazvv --exclude=.git --delete . soptor@respiratorymatters.com:respiratorymatters.com/
