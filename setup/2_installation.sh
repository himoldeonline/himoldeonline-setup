# install base dependencies and apps (you can find what packages in ./setup/distro/<distroname> )

_log_msg 'START 2_installation.sh'

if [[ $DISTRO == *Fedora* ]]; then source ./setup/distro/fedora.sh
elif [[ $DISTRO == *Debian* ]]; then source ./setup/distro/debian.sh
elif [[ $DISTRO == *Ubuntu* ]]; then source ./setup/distro/ubuntu.sh
fi

# OS-dependent installations sourced by getting correct path in distro/<distro>.sh
_log_msg 'Updating System Packages'
_update
_log_msg 'Installing Base Packages'
_install_packages 'base'
_log_msg 'Installing Tutor Dependencies'
_install_packages 'tutor'

# note: users running WSL must install docker desktop inside the Windows host manually
if ! _running_wsl; then
    if ! _has_command docker; then
      # install docker using sourced distro file
      _log_msg 'Installing Docker'
      _get_docker
    fi

  _log_msg 'Checking Docker Daemon'
  _info_validation  "Connection to Docker Daemon"
  # ..check if docker is running, enable and start docker if not
  _service_running docker &>> $_LOG_FILE ||
    # enable docker daemon if previous failed
    _add_service docker &>> $_LOG_FILE ||
    # exit if enabling docker daemon failed
    _log_tail_exit

  _info_ok 'ok'
fi

# ..validate member of docker group
if ! _in_group docker; then
  _log_msg 'Add user to docker group'
  _add_user_to_group $USER docker &>> $_LOG_FILE || _log_tail_exit
fi


# OS-independent installations

python3 -m pip install --upgrade pip  &>> $_LOG_FILE

# installing the caller for the himoldeonline manage script for managing our dev-environment
if ! _has_command himolde; then
  _log_msg 'Install the himolde caller script'
  mkdir -p ~/.local/bin
  echo -e '#!/usr/bin/env bash\nsource ~/himoldeonline/himoldeonline_setup_source/himoldeonline-setup/manage/himolde' > ~/.local/bin/himolde || _log_tail_exit
  _log_msg 'Running chmod +x on ~/.local/bin/himolde'
  chmod +x ~/.local/bin/himolde || _log_tail_exit
fi


_get_docker_compose () {
    # if docker-compose is installed, jump out of function
  if _has_command docker-compose; then return 0; fi

  _log_msg 'Installing Docker Compose'
  _info_installation "Installing Docker Compose"
  _continue
  python3 -m pip install --upgrade pip &>> $_LOG_FILE || _log_tail_exit
  pip3 install --user docker-compose &>> $_LOG_FILE || _log_tail_exit
  _info_ok 'ok'
  if _has_command docker-compose; then return 0; fi

  # if docker-compose is not callable, add to profile and export path to executable to PATH
  export PATH="$HOME/.local/bin:$PATH"
  _append_to_profile 'export PATH="$HOME/.local/bin:$PATH"'
}
_get_docker_compose


_get_xblock_sdk () {
  # xblokc sdk installation not implemented yet
  # might just grab a docker python image load up a container with exposed ports for this
  _info_installation "Installing XBlock SDK"
  _install_packages 'xblock_sdk'
}
# _get_xblock_sdk


_log_msg 'END 2_installation.sh'
