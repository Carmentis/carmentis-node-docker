#!/bin/bash

GIT_BRANCH="main"

DOCKER_COMPOSE_FILE="./docker-compose.yml"

start_app() {

    if [ -d ./.carmentis/cometbft/config ]; then
      if [ -f ./priv_validator_key.json ]; then
        echo "Copying your priv_validator_key.json to the config directory."
        cp ./priv_validator_key.json .carmentis/cometbft/config/priv_validator_key.json
      fi
    fi
    docker-compose -f $DOCKER_COMPOSE_FILE up -d --build
}

stop_app() {
    docker-compose -f $DOCKER_COMPOSE_FILE down
}

show_logs() {
    docker-compose -f $DOCKER_COMPOSE_FILE logs
}

check_status() {
    docker-compose -f $DOCKER_COMPOSE_FILE ps
}

update() {
    git pull origin $GIT_BRANCH
    docker-compose pull
    echo "Your Carmentis Node has been updated to the last version."
    echo "You can now start the services again with 'bash dev-scripts/carmentis.sh start:themis'"
}

case "$1" in
    start:themis)
        start_app
        ;;
    stop)
        stop_app
        ;;
    restart)
        stop_app
        start_app
        ;;
    reset)
        echo "This command will delete all data and storage of the Carmentis Node. Are you sure? (y/n)"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
          stop_app
          echo "Carmentis Node has been stopped."
          echo "Deleting all config & data"
          rm -rf ./.carmentis/
          echo "Your Carmentis Node has been reset. You can now start the services again with 'bash dev-scripts/carmentis.sh start:themis'"
        else
          echo "Aborted."
        fi
        ;;
    update)
        stop_app
        update
        ;;
    logs)
        show_logs
        ;;
    status)
        check_status
        ;;
    *)
        echo "Usage: $0 {start:themis|stop|restart|update|logs|status|reset}"
        exit 1
esac

exit 0
