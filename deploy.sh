#/bin/bash
set -e
touch tmp/restart.txt
rsync -Cazvv --delete . respiratorymatters:respiratorymatters.com/
