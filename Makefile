##########################
# THE MAKEFILE VARIABLES #
##########################

# The application name
APP_NAME=Psalm Plugin - Yii2

# The args that can be passed in to the makefile
ARGS=

# The project slug made from the APP_NAME
PROJECT=psalm-plugin-yii2

# The base dir of the makefile
DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

# The user id helpful for resetting file permissions
USER_ID=$(shell id -u)

##############
# BASE TASKS #
##############

help: ## Show help menu
	@echo "${APP_NAME}"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: # Installs the development dependencies
	@docker-compose -p ${PROJECT} run --rm install

update: # Updates the development dependencies
	@docker-compose -p ${PROJECT} run --rm update

test: ## Starts the application for development
	@docker-compose -p ${PROJECT} run --rm test

remove-orphans:
	@docker-compose -p ${PROJECT} up ${ARGS} -d --remove-orphans