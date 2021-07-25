# install base dependencies and apps

if [[ $DISTRO == *Fedora* ]]; then source ./setup/distro/fedora.sh
elif [[ $DISTRO == *Debian* ]]; then source ./setup/distro/debian.sh
elif [[ $DISTRO == *Ubuntu* ]]; then source ./setup/distro/ubuntu.sh
fi

# OS-dependent installations sourced by getting correct path: /setup/lib/dist_<distro>.sh
_update
_install_packages

if ! _running_wsl; then
  _get_docker
fi


# OS-independent installations
_get_pyenv () {
  PYTHON_VERSION="3.9.6"
  if ! _has_command pyenv; then
    # install pyenv
    
    _info_installation "Installing pyenv and python $PYTHON_VERSION"
    curl -s https://pyenv.run  | bash 2>&1 /dev/null

    # after install, if not call-able from $PATH
    if ! _has_command pyenv; then
      _append_to_profile 'export PATH="$HOME/.pyenv/bin:$PATH"'
      export PATH="$HOME/.pyenv/bin:$PATH"
    fi
    _append_to_profile 'eval "$(pyenv init -)"'
    _append_to_profile 'eval "$(pyenv virtualenv-init -)"'

    pyenv install -v $PYTHON_VERSION > /dev/null
    pyenv global $PYTHON_VERSION > /dev/null
  fi
}
_get_pyenv
