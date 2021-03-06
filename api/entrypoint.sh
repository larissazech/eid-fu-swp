#!/bin/bash

# wait for api database to come up
host=db; port=3306; n=120; i=0; while ! (echo > /dev/tcp/$host/$port) 2> /dev/null; do [[ $i -eq $n ]] && >&2 echo "$host:$port not up after $n seconds, exiting" && exit 1; echo "waiting for $host:$port to come up"; sleep 1; i=$((i+1)); done

# collect static files
python manage.py collectstatic --clear --noinput || exit 1

# migrate database
python manage.py migrate || exit 1

echo Finished migrations, starting API server ...
uwsgi --ini uwsgi.ini
