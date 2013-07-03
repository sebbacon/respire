To run locally:

    shotgun myapp.rb


To deploy:
    touch tmp/restart.txt
    rsync -Cazvv . respiratorymatters:respiratorymatters.com/

On the server:

    bundle # very slow
    touch tmp/restart.txt
