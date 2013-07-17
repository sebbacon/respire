#/bin/bash
set -e
touch tmp/restart.txt
rsync -Cazvv . respiratorymatters:respiratorymatters.com/
