# tutor installation and tutor commands

_install_tutor () {
  if _is_command tutor; then
    echo 'Tutor is alread installed'
    return 0
  elif ! _is_command tutor; then

    if ! _is_command docker-compose; then
      echo 'Tutor needs Docker Compose to be installed'
      exit 1
    fi
    echo "Installing Tutor"
    _dir_exist $TUTOR_ROOT || echo "Cant find directory $TUTOR_ROOT"
    pip3 install -e $TUTOR_ROOT || eval 'echo "Could not install Tutor from $TUTOR_ROOT" && return 1'

    # after install, if not call-able from $PATH
    if ! _has_command tutor; then
      _append_to_profile 'export PATH="$HOME/.local/bin:$PATH"'
      export PATH="$HOME/.local/bin:$PATH"
    fi

  fi
}

_install_open_edx () {
  tutor local quickstart && sleep 10
  tutor local stop && sleep 10
  tutor images build openedx-dev
}

_create_open_edx_admin () {
  _cnfrm='no'
  while [[ $_cnfrm != 'y' ]]
  do
    echo -e '\nType in the email address you want to use for logging into Open edX studio:'
    read EDX_EMAIL
    _yes_or_no "Is $EDX_EMAIL correct?" && _cnfrm='y'
  done
  echo "Creating new Admin Account for Open edX Studio\n"
  tutor dev createuser --staff --superuser admin $EDX_EMAIL && sleep 2
}

_bind_mount_edx_platform_source_code () {
  __src=$OPENEDX_DEV_ROOT/tutor/env/dev
  __dst=$TUTOR_ENV_ROOT/tutor/env/dev
  mkdir -p $__dst
  cp $__src/docker-compose.override.yml $__dst/docker-compose.override.yml
  # bind-mounting means we need to reinstall requirements
  sleep 2
  tutor dev run lms pip install --requirement requirements/edx/development.txt
  sleep 2
  tutor dev run lms npm install
  sleep 2
  tutor dev run lms openedx-assets build --env=dev
  sleep 2
}
