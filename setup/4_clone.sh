# clone all himoldeonline repositories

_log_msg 'Cloning Repositories'

_info_cloning "$GIT_URL_EDX_PLATFORM -> \e[0;91m$EDX_PLATFORM_ROOT/\e[0m"
git clone $GIT_URL_EDX_PLATFORM $EDX_PLATFORM_ROOT 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit

_info_cloning "$GIT_URL_OPENEDX_INSTRUCTIONS -> \e[0;91m$INSTRUCTION_ROOT/\e[0m"
git clone $GIT_URL_OPENEDX_INSTRUCTIONS $INSTRUCTION_ROOT 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit

_info_cloning "$GIT_URL_OPENEDX_DEV -> \e[0;91m$OPENEDX_DEV_ROOT/\e[0m"
git clone $GIT_URL_OPENEDX_DEV $OPENEDX_DEV_ROOT 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit

_info_cloning "$GIT_URL_TIBETHEME -> \e[0;91m$TIBE_THEME_ROOT/\e[0m"
git clone $GIT_URL_TIBETHEME $TIBE_THEME_ROOT 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit

_info_cloning "$GIT_URL_TUTOR -> \e[0;91m$TUTOR_ROOT/\e[0m"
git clone $GIT_URL_TUTOR $TUTOR_ROOT 1> /dev/null 2>> $_LOG_FILE && _info_ok || _log_tail_exit
