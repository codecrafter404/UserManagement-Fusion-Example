#!/bin/bash
############################## DEV_SCRIPT_MARKER ##############################
# This script is used to document and run recurring tasks in development.     #
#                                                                             #
# You can run your tasks using the script `./dev some-task`.                  #
# You can install the Sandstorm Dev Script Runner and run your tasks from any #
# nested folder using `dev some-task`.                                        #
# https://github.com/sandstorm/Sandstorm.DevScriptRunner                      #
###############################################################################

set -e

######### TASKS #########

# Complete deletion of containers and volumes
function nuke {
    _log_red "DANGER: Nuking your project!"
    docker compose down --rmi all --volumes --remove-orphans
    _log_green "Successfully nuked your project"
}
# Compleatly nukes the neos data, containers and volumes
function nuke-data {
    _log_red "DANGER: Nuking your project data"
    rm -rf Data
    nuke
    _log_green "Successfully nuked project data & project"
}

# Easy setup of the project
function setup() {
    _log_green "Setting up your project"
    setup-idea
    build
    _log_green "Project setup completed"
}

# Setup IDEA by running composer install
function setup-idea {
    composer install --ignore-platform-reqs
}

function start {
    docker compose up -d
    _log_green "Example User-Management application available at 127.0.0.1:8081"
}

function build {
    docker compose build
}

function stop {
    docker compose stop
}

function down {
    docker compose down -v --remove-orphans
}


function enter-db {
    docker compose exec maria-db /bin/bash
}

function enter-neos {
    docker compose exec neos /bin/bash
}

function logs {
    docker compose logs -f
}

function ps {
    docker compose ps
}

function open-site {
    open http://127.0.0.1:8081
}

function open-site-backend {
    open http://127.0.0.1:8081/login
}

####### Utilities #######
_log_green() {
  printf "\033[0;32m%s\033[0m\n" "${1}"
}
_log_yellow() {
  printf "\033[1;33m%s\033[0m\n" "${1}"
}
_log_red() {
  printf "\033[0;31m%s\033[0m\n" "${1}"
}

####### Execution Message #######
_log_green "---------------------------- RUNNING TASK: $1 ----------------------------"

# THIS NEEDS TO BE LAST!!!
# this will run your tasks
"$@"
