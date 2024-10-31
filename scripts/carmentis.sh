#!/bin/bash

#
# Copyright (c) Carmentis. All rights reserved.
# Licensed under the GPL 3.0 licence.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

GIT_BRANCH="main"

DOCKER_COMPOSE_FILE="./docker-compose.yml"

start_app() {

    if [ -d ./.carmentis/cometbft/config ]; then
      if [ -f ./priv_validator_key.json ]; then
        echo "Copying your priv_validator_key.json to the config directory."
        cp ./priv_validator_key.json .carmentis/cometbft/config/priv_validator_key.json
      fi
    fi
    docker compose -f $DOCKER_COMPOSE_FILE up -d --build
}

stop_app() {
    docker compose -f $DOCKER_COMPOSE_FILE down
}

show_logs() {
    docker compose -f $DOCKER_COMPOSE_FILE logs
}

check_status() {
    docker compose -f $DOCKER_COMPOSE_FILE ps
}

update() {
    git pull origin $GIT_BRANCH
    docker compose pull
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
