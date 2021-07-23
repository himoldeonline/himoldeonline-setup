#!/usr/bin/env bash

# Install all components and packages for Open edX to start developing
# What will be installed to run Open edX:
# ..System packages, Tutor, Docker, Docker-compose, Open edX docker images, Git, SSH-Key and more..

# todo (might implement):
# ..install xblock sdk


### Start ##################

# ..load functions and variables from these files
source ./lib/repositories.sh
source ./lib/display.sh
source ./lib/control.sh
source ./lib/system.sh
source ./lib/paths.sh
source ./lib/tutor.sh
source ./lib/time.sh
ssh-agent sh -c "ssh-add $SSH_KEY; git clone $GIT_URL_CRAFT_DOCKER $CRAFT_DOCKER_ROOT" || _continue
_banner "Checkout Docker Branch in $CRAFT_DOCKER_ROOT"
_info_display 'info' "Switching craftcms docker branch to $BRANCH_CRAFT_DOCKER"
cd $CRAFT_DOCKER_ROOT &&  ssh-agent sh -c "ssh-add $SSH_KEY; git checkout $BRANCH_CRAFT_DOCKER" || exit
