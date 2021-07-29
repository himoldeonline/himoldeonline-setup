#!/usr/bin/env bash

# What will be installed:
# ..System packages, Tutor, Docker, Docker-compose, Open edX docker images, Git, SSH-Key and more..

source ./setup/lib/display.sh
source ./setup/lib/validate.sh
source ./setup/lib/system.sh
source ./setup/lib/paths.sh
source ./setup/lib/repositories.sh
source ./setup/lib/log.sh


### Start ##################
clear
_log_init 'setup.log'
_banner '################## Setup Script for HiMolde-Online Developement Environment ##################'

_header 'Validating Environment'
source ./setup/1_environment.sh || _log_tail_exit

_header 'Installing Packages'
source ./setup/2_installation.sh || _log_tail_exit

_header 'Setting up Git Authentication'
source ./setup/3_github.sh || _log_tail_exit

_header 'Cloning Repositories'
source ./setup/4_clone.sh || _log_tail_exit

_header 'Installing Open edX'
source ./setup/5_tutor.sh || _log_tail_exit


# if script makes it to this point indicationg everything went through
_log_remove


_header 'Overview of Directorires'
echo -e "\e[1;89mRepository:\n\e[1;32mOpen edX Source Code\e[1;94m -> \e[3;91m$EDX_PLATFORM_ROOT/\e[0m\n"
echo -e "\e[1;89mRepository:\n\e[1;32mChanges we make to Open edX\e[1;94m -> \e[3;91m$OPENEDX_DEV_ROOT/\e[0m\n"
echo -e "\e[1;89mRepository:\n\e[1;32mTibe Theme for Open edX\e[1;94m -> \e[3;91m$TIBE_THEME_ROOT/\e[0m\n"
echo -e "\e[1;89mRepository:\n\e[1;32mOfficial Tutor Source Code\e[1;94m -> \e[3;91m$TUTOR_ROOT/\e[0m\n"
echo -e "\e[1;89mTutor Environment:\n\e[1;32mConfigurations for Open edX\e[1;94m -> \e[3;91m$TUTOR_ENV_ROOT/\e[0m\n"

_header 'Done!'

if ! _running_wsl; then echo 'Save all your work and press Enter to reboot' && read && reboot; fi
