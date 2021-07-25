#!/usr/bin/env bash

source ./setup/lib/display.sh
source ./setup/lib/validate.sh
source ./setup/lib/system.sh
source ./setup/lib/paths.sh
source ./setup/lib/repositories.sh
source ./setup/lib/log.sh
_log_init 'setup.log'

_get_pyenv () {
  PYTHON_VERSION="3.9.6"
  if ! _has_command pyenv; then
    # install pyenv
    
    _info_installation "Installing pyenv and python $PYTHON_VERSION"
    curl -s https://pyenv.run   | bash 

    echo "Yooooooo1"
    # after install, if not call-able from $PATH
    if ! _has_command pyenv; then
    echo "Yooooooo"
      _append_to_profile 'export PATH="$HOME/.pyenv/bin:$PATH"'
      export PATH="$HOME/.pyenv/bin:$PATH"
    fi
    _append_to_profile 'eval "$(pyenv init -)"'
    _append_to_profile 'eval "$(pyenv virtualenv-init -)"'

    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv install -v $PYTHON_VERSION 
    pyenv global $PYTHON_VERSION 
  fi
}
_get_pyenv