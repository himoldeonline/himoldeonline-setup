# validating environment

_log_msg 'START 1_environment.sh'

_info_validation 'Platform'
_PLATFORM=$(uname)
if [[ $_PLATFORM == Linux ]]; then
  export _PLATFORM && _info_ok $_PLATFORM

  # supported linux distro = extra functionality
  _info_validation  "Linux Distribution"

  DISTRO=$(cat /etc/*-release | grep -w "NAME" | cut -c 6-)
  if [[ $DISTRO == *Fedora* ]]; then DISTRO=fedora
  elif [[ $DISTRO == *Debian* ]]; then DISTRO=debian
  elif [[ $DISTRO == *Ubuntu* ]]; then DISTRO=ubuntu
  else
    _info_error "$DISTRO is not supported"; exit 1
  fi
  _info_ok $DISTRO

elif [[ $_PLATFORM == Darwin ]]; then
  export _PLATFORM && _info_ok 'MacOS'

  _info_validation  "MacOS Codename"
  A='/SOFTWARE LICENSE AGREEMENT FOR OS X/'
  B='/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf'
  _MACOS_CODENAME=$(awk "$A" "$B"  | awk -F 'OS X ' '{print $NF}' | awk '{print substr($0, 0, length($0)-1)}')
  unset A && unset B && _info_ok "$_MACOS_CODENAME"

else
  _info_error "Your platform is not supported"; exit 1

fi

# run as user
_info_validation "Script is not run as root"
  _is_root && _abort 'Script must NOT be run as root or with root privileges' || _info_ok "yes"

# root access
_info_validation; sudo -v && _info_ok "ok" || exit 1

# default shell
_info_validation "Check default shell"
_has_profiles && _info_ok $SHELL_TYPE || _abort 'Could not find any shell profile'

_info_validation "Running Windows Subsystem for Linux"
if _running_wsl; then
   _info_ok "yes"
  _info_validation "Checking if Docker Desktop is running"
  if ! _service_running docker; then
    echo -e 'Could not communicate with Docker\nGo to:'
    echo 'https://docs.docker.com/docker-for-windows/install/'
    echo 'and download, install and run docker\n..then try again'
    exit 1
  fi
   _info_ok "yes"
 else
   _info_ok "no"
fi

# .local/bin in home directory
_info_validation "$HOME.local/bin in \$PATH"
echo $PATH | grep -q "$HOME/.local/bin"
if [[ $? -ne 0 ]]; then
  _log_msg "Add $HOME/.local/bin to PATH"
  _append_to_profile 'export PATH="$HOME/.local/bin:$PATH"'
  export PATH="$HOME/.local/bin:$PATH"
fi

_log_msg 'END 1_environment.sh'
