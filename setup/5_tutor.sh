# For when running multiple tutor commands

_log_msg 'Installing Open edX with Tutor'


if ! _is_command tutor; then
  _info_installation "Tutor"
  pip3 install -e $TUTOR_ROOT || exit
fi

_tutor_from_scratch_build_dev () {
  # using our configurations, we build the images needed for running open edx dev
  # this will go through the steps equivalent to:
  # ..tutor local quickstart
  # ..tutor local stop
  # ..tutor images build openedx-dev
  tutor config save 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor local dc pull 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor local start --detach 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor local init 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor images build openedx 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor local stop 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor images build openedx-dev 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor dev start --detach 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor dev run lms pip install --requirement requirements/edx/development.txt 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor dev run lms npm install 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
  sleep 2
  tutor dev run lms openedx-assets build --env=dev 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
}
_tutor_from_scratch_build_dev && _continue
