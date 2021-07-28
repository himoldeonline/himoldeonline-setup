# For when running multiple tutor commands

_log_msg 'START 5_tutor.sh'


_log_msg 'Installing Open edX with Tutor'

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
  # using our configurations, we build the images needed for running open edx dev
  # this will go through the steps equivalent to:
  # ..tutor local quickstart
  # ..tutor local stop
  # ..tutor images build openedx-dev
  # what we end up with is both local and dev images that can be started with tutor local start and tutor dev start
  _yes_or_no "Begin installation of all Open edX docker images" || eval '_info_ok "skipping" && return 0'
  _info_installation "Getting Tutor Configurations"
  tutor config save &>> $_LOG_FILE && _info_ok 'ok'  || _log_tail_exit
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


_log_msg 'END 5_tutor.sh'
