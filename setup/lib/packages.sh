_get_pyenv () {

  _sub_info "Installing pyenv and python $PYTHON_VERSION"
  if ! _has_command pyenv; then
    curl https://pyenv.run | bash > /dev/null
    _append_to_profile 'export PATH="$HOME/.pyenv/bin:$PATH"'
    _append_to_profile 'eval "$(pyenv init -)"'
    _append_to_profile 'eval "$(pyenv virtualenv-init -)"'

    su - $USER -c "pyenv install -v $PYTHON_VERSION > /dev/null"
    su - $USER -c "pyenv global $PYTHON_VERSION > /dev/null"
  fi


}
