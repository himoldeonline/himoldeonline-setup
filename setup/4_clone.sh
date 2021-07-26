# clone all himoldeonline repositories

_log_msg 'Cloning Repositories'

_info_cloning "$GIT_URL_EDX_PLATFORM -> \e[0;91m$EDX_PLATFORM_ROOT/\e[0m"
  ssh-agent sh -c "ssh-add $SSH_KEY; git clone $GIT_URL_EDX_PLATFORM $EDX_PLATFORM_ROOT" &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  _info_cloning "Fething all tags"
  cd $EDX_PLATFORM_ROOT && ssh-agent sh -c "ssh-add $SSH_KEY; git fetch --all --tags"  &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  _info_checkout "Checking out tag $TAG_EDX_PLATFORM"
  cd $EDX_PLATFORM_ROOT && git checkout $TAG_EDX_PLATFORM  &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit

_info_cloning "$GIT_URL_OPENEDX_INSTRUCTIONS -> \e[0;91m$INSTRUCTION_ROOT/\e[0m"
  ssh-agent sh -c "ssh-add $SSH_KEY; git clone $GIT_URL_OPENEDX_INSTRUCTIONS $INSTRUCTION_ROOT" &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit

_info_cloning "$GIT_URL_OPENEDX_DEV -> \e[0;91m$OPENEDX_DEV_ROOT/\e[0m"
  ssh-agent sh -c "ssh-add $SSH_KEY; git clone $GIT_URL_OPENEDX_DEV $OPENEDX_DEV_ROOT" &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  _info_checkout "Checking out branch $BRANCH_OPENEDX_DEV"
  cd $OPENEDX_DEV_ROOT && git checkout $BRANCH_OPENEDX_DEV &>> $_LOG_FILE  && _info_ok 'ok' || _log_tail_exit

_info_cloning "$GIT_URL_TIBETHEME -> \e[0;91m$TIBE_THEME_ROOT/\e[0m"
  ssh-agent sh -c "ssh-add $SSH_KEY; git clone $GIT_URL_TIBETHEME $TIBE_THEME_ROOT" &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit

_info_cloning "$GIT_URL_TUTOR -> \e[0;91m$TUTOR_ROOT/\e[0m"
  ssh-agent sh -c "ssh-add $SSH_KEY; git clone $GIT_URL_TUTOR $TUTOR_ROOT" &>> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
