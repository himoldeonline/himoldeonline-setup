#!/usr/bin/env bash

# Install all components and packages for Open edX to start developing
# What will be installed to run Open edX:
# ..System packages, Tutor, Docker, Docker-compose, Open edX docker images, Git, SSH-Key and more..

# todo (might implement):
# ..install xblock sdk
source ./setup/lib/display.sh
source ./setup/lib/validate.sh
source ./setup/lib/system.sh
source ./setup/lib/variables.sh
source ./setup/lib/log.sh


### Start ##################

# ..load functions and variables from these files

_log_init

clear



# _header 'Validating Environment'
# source ./setup/1_environment.sh

# _header 'Installing Packages'
# source ./setup/2_installation.sh

_header 'Setting up Git Authentication'
source ./setup/3_github.sh

# _header 'Cloning Repositories'
# source ./setup/4_clone.sh


# remove log if script makes it to this point
# _log_remove
