# clone all himoldeonline repositories

_log_msg 'START 4_clone.sh'

_clone_git_repository () {
  # 1st arg: URL
  # 2nd arg: DIR
  _info_cloning "$1 -> \e[0;91m$2/\e[0m"
  if _service_running ssh-agent; then
    ssh-agent sh -c "ssh-add $SSH_KEY; git clone $1 $2" >> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  else
    git clone $1 $2 >> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
  fi
}

_checkout_tags () {
  # 1st arg: DIR
  # 2nd arg: TAG
  _info_checkout "Fetching all tags in \e[0;91m$1/\e[0m and checking out $2"
  cd $1 || _log_tail_exit
  if _service_running ssh-agent; then
    ssh-agent sh -c "ssh-add $SSH_KEY; git fetch --all --tags"  >> $_LOG_FILE || _log_tail_exit
  else
    git fetch --all --tags  >> $_LOG_FILE || _log_tail_exit
  fi
  cd $1 && git checkout $2  >> $_LOG_FILE && _info_ok 'ok' || _log_tail_exit
}

_checkout_branch () {
  # 1st arg: DIR
  # 2nd arg: BRANCH
  _info_checkout "Checking out branch $2 in \e[0;91m$1/\e[0m"
  cd $1 && git checkout $2 >> $_LOG_FILE  && _info_ok 'ok' || _log_tail_exit
}

__start_git_clone () {
  # 1st arg: CLONE DIRECTORY
  # 2nd arg: GIT URL
  if _dir_can_clone $1; then
    _log_msg "Cloning $2" && _clone_git_repository $2 $1
  elif _is_cloned $1; then
    _log_msg "Skip cloning $2 because a git repository inside $1 exists"
  elif ! _is_cloned $1; then
    _log_msg "$2 can not be cloned because $1 is not empty"
    _log_tail_exit
  fi
}

# clone repositories
_START_DIRECTORY=$(pwd) # preserve the original woring directory
__start_git_clone $EDX_PLATFORM_ROOT $GIT_URL_EDX_PLATFORM
__start_git_clone $INSTRUCTION_ROOT $GIT_URL_OPENEDX_INSTRUCTIONS
__start_git_clone $OPENEDX_DEV_ROOT $GIT_URL_OPENEDX_DEV
__start_git_clone $TIBE_THEME_ROOT $GIT_URL_TIBETHEME
__start_git_clone $TUTOR_ROOT $GIT_URL_TUTOR
__start_git_clone $SETUP_ROOT $GIT_URL_SETUP
__start_git_clone $WEB_PORTAL_ROOT $GIT_URL_WEB_PORTAL
__start_git_clone $PRACTICE_ROOT $GIT_URL_PRACTICE

# checkout branches and tags
_checkout_tags $EDX_PLATFORM_ROOT $TAG_EDX_PLATFORM
_checkout_branch $OPENEDX_DEV_ROOT $BRANCH_OPENEDX_DEV

cd $_START_DIRECTORY # go back to original directory

_log_msg 'END 4_clone.sh'
