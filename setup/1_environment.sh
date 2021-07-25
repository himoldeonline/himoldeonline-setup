# validating environment


DISTRO=$(cat /etc/*-release | grep -w "NAME" | cut -c 6-)

_info_validation  "Distro is either Debian, Fedora or Ubuntu"
  _distro_supported && _info_ok $DISTRO || _abort "You are not running a supported distribution of Linux"

_info_validation  "Script is not run as root"
  _is_root && _abort 'Script must NOT be run as root or with root privileges' || _info_ok "yes"

  _ROPOSITORIES=(
    $REPO_TUTOR $REPO_TIBETHEME $REPO_OPENEDX_DEV $REPO_INSTRUCTION $REPO_OPENEDX_PLATFORM
  )
  for repo in "${_ROPOSITORIES[@]}"; do
    _info_validation  "\e[0;91m$DEV_ROOT/\e[0m does not exist or is empty"
    if _dir_exist $repo; then
      if ! _dir_empty $repo; then
<<<<<<< HEAD
        _sub_info "Directory is not empty and will be removed" && \
        _continue && \
        _sub_info "Removing $repo" \
         && rm -rf $repo  || _log_error "Could not delete $repo"
=======
        _sub_info "Directory is not empty and will be removed" &&
        _continue &&  _sub_info "Removing $repo"
         rm -rf $repo  || _log_error "Could not delete $repo"
>>>>>>> 9984bbad19ee466a614ef872d1fe13fe24a7ed36
      fi
    fi
    _info_ok
  done

_info_validation "Check if .bashrc and/or .zshrc"
_has_profiles && _info_ok $SHELL_TYPE || _abort 'Could not find any shell profile'

_info_validation  "Checking if running inside Windows Subsystem for Linux"
if _running_wsl; then
   _info_ok "yes"
  _info_validation  "Checking if Docker Desktop is running"
  if ! _service_running docker; then
    M1='Could not communicate with Docker\nMake sure to go to:'
    M2='\nhttps://docs.docker.com/docker-for-windows/install/'
    M3='\n..in your Windows host and download, install and run docker\n..then try again'
    _abort "$M1 $M2 $M3"
  fi
   _info_ok "yes"
fi
