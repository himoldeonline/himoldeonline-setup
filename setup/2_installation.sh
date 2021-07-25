# install base dependencies and apps (you can find what packages in ./setup/distro/<distroname> )

if [[ $DISTRO == *Fedora* ]]; then source ./setup/distro/fedora.sh
elif [[ $DISTRO == *Debian* ]]; then source ./setup/distro/debian.sh
elif [[ $DISTRO == *Ubuntu* ]]; then source ./setup/distro/ubuntu.sh
fi

# OS-dependent installations sourced by getting correct path in distro/<distro>.sh
_update
_install_packages

# users running WSL must install docker desktop inside the Windows host
if ! _running_wsl; then
  _get_docker
fi


# OS-independent installations
_get_pyenv () {
  PYTHON_VERSION="3.9.6"
  if ! _has_command pyenv; then
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
  fi
}
_get_pyenv
