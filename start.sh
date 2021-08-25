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
_banner '################## Setup Script for HiMolde-Online Developement Environment ##################'

_header 'Validating Environment'
source ./setup/1_environment.sh || _log_tail_exit

_header 'Installing Packages'
source ./setup/2_installation.sh || _log_tail_exit

_header 'Setting up Git Authentication'
source ./setup/3_github.sh || _log_tail_exit

_header 'Cloning Repositories'
source ./setup/4_clone.sh || _log_tail_exit

# _header 'Installing Open edX'
# source ./setup/5_tutor.sh || _log_tail_exit
#
# _header 'Installing Nitro'
# source ./setup/6_nitro.sh || _log_tail_exit


_header 'Overview: Directorires'
echo -e "\e[1;89mRepository:\n\e[1;32mOpen edX Source Code\e[1;94m -> \e[3;91m$EDX_PLATFORM_ROOT/\e[0m\n"
echo -e "\e[1;89mRepository:\n\e[1;32mChanges we make to Open edX\e[1;94m -> \e[3;91m$OPENEDX_DEV_ROOT/\e[0m\n"
echo -e "\e[1;89mRepository:\n\e[1;32mTibe Theme for Open edX\e[1;94m -> \e[3;91m$TIBE_THEME_ROOT/\e[0m\n"
echo -e "\e[1;89mRepository:\n\e[1;32mSetup and tools for himoldeonline\e[1;94m -> \e[3;91m$SETUP_ROOT/\e[0m\n"
echo -e "\e[1;89mRepository:\n\e[1;32mOfficial Tutor Source Code\e[1;94m -> \e[3;91m$TUTOR_ROOT/\e[0m\n"
echo -e "\e[1;89mRepository:\n\e[1;32mFor practising git, coding and teamwork\e[1;94m -> \e[3;91m$PRACTICE_ROOT/\e[0m\n"
echo -e "\e[1;89mTutor Environment for Open edX:\n\e[1;32mConfigurations for Open edX\e[1;94m -> \e[3;91m$TUTOR_ENV_ROOT/\e[0m\n"
echo -e "\e[1;89mTutor Executable:\n\e[1;32mPath where tutor is started from\e[1;94m -> \e[3;91m$HOME/.local/bin/tutor\e[0m\n"
echo -e "\e[1;89mManage Script for Dev-Environmet:\n\e[1;32mPath where himolde is started from\e[1;94m -> \e[3;91m$HOME/.local/bin/himolde\e[0m\n"
echo -e "\e[1;89mNitro Executable:\n\e[1;32mPath where nitro is started from\e[1;94m -> \e[3;91m$HOME/.local/bin/nitro\e[0m\n"

_header 'Done!'

if ! _running_wsl; then echo 'You should do a reboot for any changes to reload'; fi
