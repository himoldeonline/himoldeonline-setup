# For when running multiple tutor commands

_log_msg 'START 5_tutor.sh'


# install tutor if not installed
if ! _is_command tutor; then
  if ! _is_command docker-compose; then
    _info_error 'Tutor needs Docker Compose to be installed'
    _log_tail_exit
  fi
  _log_msg 'Installing Tutor'
  _info_installation "Tutor\n"
  eval 'pip3 install -e $TUTOR_ROOT' &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit

  # after install, if not call-able from $PATH
  if ! _has_command tutor; then
    _append_to_profile 'export PATH="$HOME/.local/bin:$PATH"'
    export PATH="$HOME/.local/bin:$PATH"
  fi

fi

# add hosts if not added
_log_msg 'Adding hosts if not added'
_add_host "127.0.0.1" "local.overhang.io" && _add_host "127.0.0.1" "studio.local.overhang.io"


_tutor_from_scratch_build_dev () {
  _log_msg 'Running: _tutor_from_scratch_build_dev'
  # using our configurations, we build the images needed for running open edx dev
  # this will go through the steps equivalent to:
  # ..tutor local quickstart
  # ..tutor local stop
  # ..tutor images build openedx-dev
  # what we end up with is both local and dev images that can be started with tutor local start and tutor dev start
  _yes_or_no "Run the Tutor installation of all Open edX docker images" || eval '_info_ok "skipping" && return 0'
  _info_installation "Getting Tutor Configurations"

  # ..transfer our tutor config (THIS REQUIRES THAT WE HAVE CLONED openedx-dev) files to the tutor root environment for Open edX
  _dir_exist $TUTOR_ENV_ROOT || mkdir -p $TUTOR_ENV_ROOT
  rsync -au $OPENEDX_DEV_ROOT/tutor/ $TUTOR_ENV_ROOT/ || _log_tail_exit
  tutor config save &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  sleep 2

  # running commands with the docker user id (notice the leading 'sg docker -c')
  _info_installation "Pulling Open edX Docker Image"
  sg docker -c "tutor local dc pull"
  sleep 2

  _info_installation "Starting up container (running a fresh copy of Open edX) from pulled Image"
  sg docker -c "tutor local start --detach"
  sleep 2

  _info_installation "Initiate Open edX: Databases, Migrations and Applications"
  sg docker -c "tutor local init"
  sleep 2

  _info_installation "Build new Open edX Image from current running Contianer"
  sg docker -c "tutor images build openedx"
  sleep 2

  _info_installation "Stopping Container"
  sg docker -c "tutor local stop"
  sleep 2

  _info_installation "Build new Developement Image with extra assets"
  sg docker -c "tutor images build openedx-dev"
  sleep 2

  _info_installation "Start the Open edX Developement Environment"
  sg docker -c "tutor dev start --detach"
  sleep 2

  _info_installation "Start up Open edX and install the extra assets"
  sg docker -c "tutor dev run lms pip install --requirement requirements/edx/development.txt"
  sleep 2
  sg docker -c "tutor dev run lms npm install"
  sleep 2
  sg docker -c "tutor dev run lms openedx-assets build --env=dev"
}
_tutor_from_scratch_build_dev


_tutor_post_installation_setup () {
    _yes_or_no "Run the Tutor post installation setup for (setting admin account for Open edX and Tibe-theme etc.)" || eval '_info_ok "skipping" && return 0'
  _log_msg 'Running: _tutor_post_installation_setup'

  _cnfrm='no'
  while [[ $_cnfrm != 'y' ]]
  do
    echo -e '\nType in the email address you want to use for logging into Open edX studio:'
    read EDX_EMAIL
    _yes_or_no "Is $EDX_EMAIL correct?" && _cnfrm='y'
  done
  _info_installation "Creating new Admin Account for Open edX Studio\n"
  sg docker -c "tutor dev createuser --staff --superuser admin $EDX_EMAIL && sleep 2"

  _info_installation "Activating Theme for Open edX"
  sg docker -c "tutor dev settheme tibetheme local.overhang.io:8000 studio.local.overhang.io:8001 && sleep 2"

  # ..rebuild the openedx  dev image
  _info_installation "Rebuilding Open edX Developement Image"
  sg docker -c "tutor images build openedx-dev && sleep 2"

  # ..stop any running openedx dev conatainer and reboot
  _info_installation "Stopping All Running Open edX Containers"
  sg docker -c "tutor dev stop && sleep 2"
}
_tutor_post_installation_setup


_log_msg 'END 5_tutor.sh'
