# Carmentis Node

This document provides instructions on how to launch, manage, and interact with the Carmentis Node using Docker and Docker Compose. Instructions are provided for both Unix and Windows operating systems.

## Prerequisites

Before proceeding, ensure you have the following installed:
- Docker
- Docker Compose

## Setup

Clone the repository and navigate to the directory where the `docker-compose.yml` file is located.

## Managing the Application

1. **Starting the Application (on Themis network):** Run `./scripts/carmentis.sh start:themis` to start the application. This command launches the Node services in detached mode.

2. **Stopping the Application:** Execute `./scripts/carmentis.sh stop` to stop and remove container instances.

3. **Restarting the Application:** Use `./scripts/carmentis.sh restart` to restart the Operator service.

4. **Viewing Logs:** To view the application logs, run `./scripts/carmentis.sh logs`.

5. **Checking the Status:** For the current status of the service, execute `./scripts/carmentis.sh status`.
6. **Upgrading the Application:** To upgrade the application to the latest update, run `./scripts/carmentis.sh update`. It will stop the current running services, pulls the latest image, and starts the services again.
7. **Resetting the Application:** To reset the application's database, execute `./scripts/carmentis.sh reset`.

## Additional Notes

- Ensure all environment variables and configurations are set correctly in your `.env` file.
- To start the Carmentis Node as validator, you need to provide the validator key (to do before being whitelisted by the network). The validator key should be placed in the Carmentis node directory. Restart the node after placing the validator key if the node is already running.
- The .carmentis directory is created in the root directory of the project. It contains the data and configuration files for the Carmentis Node.

You should take care to back up the files in .data regularly.
