# install base dependencies and apps

if [[ $DISTRO == *Fedora* ]]; then source ./setup/lib/dist_fedora.sh
elif [[ $DISTRO == *Debian* ]]; then source ./setup/lib/dist_debian.sh
elif [[ $DISTRO == *Ubuntu* ]]; then source ./setup/lib/dist_ubuntu.sh
fi

# OS-dependent installations sourced by getting correct path: /setup/lib/dist_<distro>.sh
_update
_install_packages
_get_docker

# OS-independent installations
_get_pyenv () {
  _sub_info "Installing pyenv and python $PYTHON_VERSION"
  if ! _has_command pyenv; then
    curl https://pyenv.run | bash > /dev/null
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
# _get_pyenv
