@echo off
SET GIT_BRANCH=main
SET DOCKER_COMPOSE_FILE=./docker-compose.yml

IF "%1"=="start" (
    docker-compose -f %DOCKER_COMPOSE_FILE% up -d --build
    GOTO End
)

IF "%1"=="stop" (
    docker-compose -f %DOCKER_COMPOSE_FILE% down
    GOTO End
)

IF "%1"=="restart" (
    docker-compose -f %DOCKER_COMPOSE_FILE% down
    docker-compose -f %DOCKER_COMPOSE_FILE% up -d --build
    GOTO End
)

IF "%1"=="reset" (
    echo "This command will delete all data and storage of the Carmentis Node. Are you sure? (y/n)"
    set /p answer=
    IF /I "%answer%"=="y" (
        docker-compose -f %DOCKER_COMPOSE_FILE% down
        rmdir /s /q .\.data\*
        docker-compose -f %DOCKER_COMPOSE_FILE% up -d --build
    ) ELSE (
        echo Aborted.
    )
    GOTO End
)

IF "%1"=="update" (
    docker-compose -f %DOCKER_COMPOSE_FILE% down
    git pull origin %GIT_BRANCH%
    docker-compose pull
    docker-compose -f %DOCKER_COMPOSE_FILE% up -d --build
    GOTO End
)

IF "%1"=="logs" (
    docker-compose -f %DOCKER_COMPOSE_FILE% logs
    GOTO End
)

IF "%1"=="status" (
    docker-compose -f %DOCKER_COMPOSE_FILE% ps
    GOTO End
)

:Usage
echo Usage: %0 {start|stop|restart|update|logs|status|reset}
exit /b 1

:End
exit /b 0
