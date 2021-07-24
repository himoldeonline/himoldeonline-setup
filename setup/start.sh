#!/usr/bin/env bash

# What will be installed:
# ..System packages, Tutor, Docker, Docker-compose, Open edX docker images, Git, SSH-Key and more..

source ./lib/display.sh
source ./lib/validate.sh
source ./lib/system.sh
source ./lib/paths.sh
source ./lib/repositories.sh
source ./lib/log.sh


### Start ##################
clear
_log_init 'setup.log'
_banner 'Setup Script for HiMolde-Online Developement Environment'

_header 'Validating Environment'
source ./setup/1_environment.sh

_header 'Installing Packages'
source ./setup/2_installation.sh

_header 'Setting up Git Authentication'
source ./setup/3_github.sh

_header 'Cloning Repositories'
source ./setup/4_clone.sh

_header 'Installing Open edX'
source ./setup/5_tutor.sh


# if script makes it to this point indicationg everything went through
_log_remove

_header 'Done!'
