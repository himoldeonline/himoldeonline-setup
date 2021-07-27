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

  # ..validate member of docker group
  if ! _in_group docker; then
    _log_msg 'Add user to docker group'
    _add_user_to_group $USER docker &>> $_LOG_FILE || _log_tail_exit
  fi

  _info_ok 'ok'
fi


# OS-independent installations
_get_pyenv () {
  # if pyenv is installed and python is installed, jump out of function
  if _has_command pyenv; then
      if _has_command python; then return 0; fi
  fi

  if ! _has_command pyenv; then
    PYTHON_VERSION="3.9.6"
    _yes_or_no "Do you want to install Pyenv with Python $PYTHON_VERSION" || eval '_info_ok "skipping" && return 0'

    _log_msg "Installing pyenv and $PYTHON_VERSION"
    _install_packages 'pyenv'
    _info_installation "Installing pyenv and python $PYTHON_VERSION"
    eval "curl https://pyenv.run/ | bash" &>> $_LOG_FILE || _log_tail_exit

    # after install, if not call-able from $PATH
    if ! _has_command pyenv; then
      _append_to_profile 'export PATH="$HOME/.pyenv/bin:$PATH"'
      export PATH="$HOME/.pyenv/bin:$PATH"
    fi
    _append_to_profile 'eval "$(pyenv init -)"'
    _append_to_profile 'eval "$(pyenv virtualenv-init -)"'

    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv install -v $PYTHON_VERSION &>> $_LOG_FILE || _log_tail_exit
    pyenv global $PYTHON_VERSION &>> $_LOG_FILE || _log_tail_exit
    _info_ok 'ok'
  fi


}
_get_pyenv


_get_docker_compose () {
    # if docker-compose is installed, jump out of function
  if _has_command docker-compose; then
     return 0
  fi
  _log_msg 'Installing Docker Compose'
  _info_installation "Installing Docker Compose"
  python3 -m pip install --upgrade pip &>> $_LOG_FILE || _log_tail_exit
  pip3 install docker-compose &>> $_LOG_FILE || _log_tail_exit
  _info_ok 'ok'
}
_get_docker_compose


_get_xblock_sdk () {
  # xblokc sdk installation not implemented yet
  # might just grab a docker python image load up a container with exposed ports for this
  _info_installation "Installing XBlock SDK"
  _install_packages 'xblock_sdk'
}


_log_msg 'END 2_installation.sh'
