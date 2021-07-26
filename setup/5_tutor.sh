# For when running multiple tutor commands

_log_msg 'Installing Open edX with Tutor'


if ! _is_command tutor; then
  if ! _is_command docker-compose; then
    _info_error 'Tutor needs Docker Compose to be installed'
    _log_tail_exit
  fi
  _info_installation "Tutor\n"
  _install_packages 'tutor'
  eval 'pip3 install -e $TUTOR_ROOT' &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
fi

_tutor_from_scratch_build_dev () {
  # using our configurations, we build the images needed for running open edx dev
  # this will go through the steps equivalent to:
  # ..tutor local quickstart
  # ..tutor local stop
  # ..tutor images build openedx-dev
  # what we end up with is both local and dev images that can be started with tutor local start and tutor dev start
  _info_installation "Getting Tutor Configurations"
  tutor config save &>> $_LOG_FILE && _info_ok 'ok'  || _log_tail_exit
  sleep 2

  _info_installation "Pulling Open edX Docker Image"
  tutor local dc pull &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  sleep 2

  _info_installation "Starting up container (running a fresh copy of Open edX) from pulled Image"
  tutor local start --detach &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  sleep 2

  _info_installation "Initiate Open edX: Databases, Migrations and Applications"
  tutor local init &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  sleep 2

  _info_installation "Build new Open edX Image from current running Contianer"
  tutor images build openedx &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  sleep 2

  _info_installation "Stopping Container"
  tutor local stop &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  sleep 2

  _info_installation "Build new Developement Image with extra assets"
  tutor images build openedx-dev &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  sleep 2

  _info_installation "Start the Open edX Developement Environment"
  tutor dev start --detach &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  sleep 2

  _info_installation "Start up Open edX and install the extra assets"
  tutor dev run lms pip install --requirement requirements/edx/development.txt &>> $_LOG_FILE || _log_tail_exit
  sleep 2
  tutor dev run lms npm install &>> $_LOG_FILE || _log_tail_exit
  sleep 2
  tutor dev run lms openedx-assets build --env=dev &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
}
_tutor_from_scratch_build_dev
