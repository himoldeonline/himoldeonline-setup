# fetch system settings and do validations

_is_root () {
  # returns:
  # ..0 = is root
  # ..1 = not root
  _UID=$(id -u)
  if [ $_UID -ne '0' ]; then
     return 1
  fi
  return 0
}

_has_profiles () {
  # sets path for shell profile in $SH_PROFILE
  # returns:
  # ..1 = no shell profile found
  if [[ -f ~/.bashrc ]]; then
    return 0
  elif [[ -f ~/.zshrc ]]; then
    return 0
  else
    return 1
  fi
}

_running_wsl () {
  # returns:
  # ..0 = running nside wsl
  # ..1 = not running inside wsl
  uname -r | grep -q "WSL2"
  if [[ $? == '0' ]]; then
    return 0
  fi
  return 1
}

_service_running () {
  # 1st arg: name-of-service
  # returns:
  # ..0 = running
  # ..1 = not running
  _SERVICE=$1
  RET=$(pgrep -f $_SERVICE)
  if [[ $? == '1' ]]; then
    return 1
  fi
  return 0
}

_user_exist () {
  # returns:
  # ..0 = exist
  # ..1 = does not exist
  getent passwd $1 | grep -q $1
  if [[ $? -eq '1' ]]; then
    return 1
  fi
  return 0
}

_home_exist () {
  # returns:
  # ..0 = home dir exist (and match home input if passed)
  # ..1 = home dir does not exist
  # ..2 = optional input home dir does not match home dir in passwd
  # example usage: if _home_exist <uername>; then...
  CMD=$(eval echo "~$1")
  RET=$CMD
  if [[ ! -d $RET ]]; then
    return 1
  fi

  return 0
}

_file_exist () {
  # returns:
  # ..0 = file exist
  # ..1 = file does not exist
  _FILE=$1
  if [[ -f $_FILE ]]; then
      return 0
  fi
  return 1
}

_dir_exist () {
  # returns:
  # ..0 = directory exist
  # ..1 = directory does not exist
  _PATH=$1
  if [[ -d $_PATH ]]; then
      return 0
  fi
  return 1
}

# _exists ()
# {
#   _validation  "Check if \e[0;31m$1\e[0 is nonempty"
#   _is_nonempty $1 &&  _sub_info "Directory $1 is non-empty. The folder will be overwritten. " && _continue
#
# }

_is_nonempty () {
  # returns:
  # ..0 = directory is empty
  # ..1 = directory is not empty
  # ..2 = directory does not exist
  if [ -d $1 ]; then
    if [ "$(ls -A $1)" ]; then
       return 0
     fi
     return 1
  fi
  return 1
}

_dir_empty () {
  # returns:
  # ..0 = directory is empty
  # ..1 = directory is not empty
  # ..2 = directory does not exist
  if [ -d $1 ]; then
    if [ "$(ls -A $1)" ]; then
       return 1
     fi
     return 0
  fi
  return 2
}

_ssh_github_validate () {
  # returns:
  # ..0 = authenticated
  # ..1 = denied
  ssh -i $SSH_KEY -T git@github.com 2> /dev/null
  IS_AUTH=$? # 1 = authenticated, 255 = denied
  if [[ $IS_AUTH -eq '1' ]]
    then return 0; else return 1
  fi
}

_check_path () {
  # returns:
  # ..0: in $PATH
  # ..1: not in $PATH
  echo $PATH | grep -q $1 || return 1
  return 0
}

_is_command () {
  # example usage: _is_command tutor && echo 'tutor exist'|| echo 'tutor does not exist'
  # returns:
  # ..0 = command exist
  # ..1 = command does not exist
  if [ -x "$(command -v $1)" ]; then return 0
  else return 1; fi
}

_in_group () {
  # 1st arg: groupname
  # returns:
  # ..0 = in group
  # ..1 = not in group
  getent group $1 | grep -q $USER && return 0 || return 1
}

_print_ssh_pub () {
  echo -e '\n---ssh-pub-key---\n'
  cat $SSH_KEY_PUB
  echo -e '\n---ssh-pub-key---\n'
}

_distro_supported () {
  DISTRO=$(cat /etc/*-release | grep -w "NAME" | cut -c 6-)
  if [[ $DISTRO == *Fedora* ]]; then return 0
  elif [[ $DISTRO == *Debian* ]]; then return 0
  elif [[ $DISTRO == *Ubuntu* ]]; then return 0
  else return 1; fi

}

_has_command() {
  if command -v $1 &> /dev/null
  then return 0
  else return 1
  fi
}
