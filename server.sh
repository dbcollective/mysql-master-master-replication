#!/bin/bash

if [[ $# -lt 1 && $# -gt 2 ]]; then
    echo 'Too many/few arguments, expecting one' >&2
    exit 1
fi

case $1 in
    boot)
        docker-compose down && docker-compose up -d ;;
    start)
        docker-compose up -d ;;
    restart)
        docker-compose restart ;;
    stop)
        docker-compose down ;;
    master01|master02)
        set -o allexport
        source .env
        set +o allexport
        if [[ $2 = '--root' ]]
        then
            echo "Connecting to $DATABASE database on $1 server with user root"
            docker-compose exec -it $1 /bin/bash -c "export MYSQL_PWD=$ROOT_PASSWORD; mysql -u root $DATABASE"
        else
            echo "Connecting to $DATABASE database on $1 server with user $DB_USER"
            docker-compose exec -it $1 /bin/bash -c "export MYSQL_PWD=$USER_PASSWORD; mysql -u $DB_USER $DATABASE"
        fi
        ;;
    *)
        # The wrong first argument.
        echo 'Expected "start", "restart", "stop", "boot", "master01" or "master02"' >&2
        exit 1
esac