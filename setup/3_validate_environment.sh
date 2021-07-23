

_validation  "Check if distro is either Debian, Fedora or Ubuntu"
is_distro_supported || _abort "You are not running a supported distribution of Linux"
_passed


_validation  "Checking if script is run as root"
_is_root && _abort 'Script must NOT be run as root or with root privileges'
_passed


_exists $REPO_TUTOR
_exists $REPO_TIBETHEME
_exists $REPO_OPENEDX_DEV
_exists $REPO_INSTRUCTION
_exists $REPO_OPENEDX_PLATFORM


_validation  "Check if one of .bashrc or .zshrc exists"
_has_profiles || _abort 'Could not find shell profile'
_passed


_validation  "Checking if wsl is running"
if _running_wsl; then
  if ! _service_running docker; then
    M1='Could not communicate with Docker\nMake sure to go to:'
    M2='\nhttps://docs.docker.com/docker-for-windows/install/'
    M3='\n..in your Windows host and download, install and run docker\n..then try again'
    _abort "$M1 $M2 $M3"
  fi
fi
_passed



