# install base dependencies and apps (you can find what packages in ./setup/distro/<distroname> )

if [[ $DISTRO == *Fedora* ]]; then source ./setup/distro/fedora.sh
elif [[ $DISTRO == *Debian* ]]; then source ./setup/distro/debian.sh
elif [[ $DISTRO == *Ubuntu* ]]; then source ./setup/distro/ubuntu.sh
fi

# OS-dependent installations sourced by getting correct path in distro/<distro>.sh
_update
_install_packages

# note: users running WSL must install docker desktop inside the Windows host manually
if ! _running_wsl; then

  # install docker from sourced distro file
  _get_docker


  _info_validation  "Connection to Docker Daemon"
  # ..check if docker is running, enable and start docker if not
  _service_running docker &>> $_LOG_FILE ||
    # enable docker daemon if previous failed
    _add_service docker &>> $_LOG_FILE ||
    # exit if enabling docker daemon failed
    _log_tail_exit

  # ..validate member of docker group
  if ! _in_group docker; then
    _add_user_to_group $USER docker &>> $_LOG_FILE || _log_tail_exit
  fi

fi


# OS-independent installations
_get_pyenv () {
  # if pyenv is installed and python is installed, jump out of function
  if _has_command pyenv; then
      if _has_command python; then return 0; fi
  fi

  if ! _has_command pyenv; then
    PYTHON_VERSION="3.9.6"
    _yes_or_no "Do you want to install Pyenv and Python $PYTHON_VERSION" || eval '_info_ok "skipping" && return 0'
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
    # if docker-compose is isntalled, jump out of function
  if _has_command docker-compose; then
     return 0
  fi
  _info_installation "Installing Docker Compose"
  python3 -m pip install --upgrade pip &>> $_LOG_FILE || _log_tail_exit
  pip3 install docker-compose &>> $_LOG_FILE || _log_tail_exit
  _info_ok 'ok'
}
_get_docker_compose
