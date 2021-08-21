# install base dependencies and apps (you can find what packages in ./setup/os/<os>.sh )

_log_msg 'START 2_installation.sh'

__mac_installations () {

  source ./setup/os/macos.sh

  # homebrew
  if ! _has_command brew; then
    _log_msg 'Installing Homebrew'
    _get_homebrew && echo 'Press Enter'; read
  fi

  _log_msg 'Installing Tutor Dependencies'
  _get_tutor_dependencies

  # python3
  if ! _has_command python3; then
    _log_msg 'Installing Python 3'
    _get_python
  fi

  # docker
  if ! _has_command docker; then
    _log_msg 'Installing Docker'
    _get_docker
  fi

}

__linux_installations () {

  source ./setup/os/$DISTRO.sh

  # OS-dependent installations sourced by getting correct path in os/<os>.sh
  _log_msg 'Updating System Packages'
  _update
  _log_msg 'Installing Base Packages'
  _install_packages 'base'
  _log_msg 'Installing Tutor Dependencies'
  _install_packages 'tutor'

  # note: users running WSL must install docker desktop inside the Windows host manually
  if ! _running_wsl; then
      if ! _has_command docker; then
        # install docker using sourced os file
        _log_msg 'Installing Docker'
        _get_docker
      fi

    _log_msg 'Checking Docker Daemon'
    _info_validation  "Checking if Docker Daemon is running"
    if ! _service_running docker; then
      _log_msg 'Enable Docker Daemon'
      _enable_service docker || _log_tail_exit
    fi
    _info_ok 'ok'

    _info_validation  "$USER is part of Docker group"
    if ! _in_group docker; then
      _log_msg "Adding $USER to docker group"
      echo "Adding $USER to the docker group"
      _add_user_to_group $USER docker || _log_tail_exit
    fi
    _info_ok 'ok'
  fi
}

if [[ $_PLATFORM == Darwin ]]
  then __mac_installations
elif [[ $_PLATFORM == Linux ]]
  then __linux_installations
fi


# OS-independent installations

# add a new directory if not already in $PATH
echo $PATH | grep -q -w "$HOME/.local/bin" || _append_to_profile 'export PATH="$HOME/.local/bin:$PATH"'

# upgrade pip for python
if ! _is_command python3; then echo 'Python3 is not installed'; exit 1; fi
python3 -m pip install --upgrade pip  >> $_LOG_FILE


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
  python3 -m pip install --upgrade pip >> $_LOG_FILE || _log_tail_exit
  pip3 install --user docker-compose >> $_LOG_FILE || _log_tail_exit
  _info_ok 'ok'
  if _has_command docker-compose; then return 0; fi

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
