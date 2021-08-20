# fetch system settings and do validations

_is_root () {
  _UID=$(id -u)
  if [[ $_UID -ne '0' ]]; then
     return 1 # not root
  fi
  return 0 # is root
}

_has_profiles () {
  # also sets path for shell profile in $SH_PROFILE
  echo $SHELL | grep -w -q "zsh" && SHELL_TYPE="zsh" && return 0
  echo $SHELL | grep -w -q "bash" && SHELL_TYPE="bash" && return 0
  return 1 # no shell profile found
}

_running_wsl () {
  uname -r | grep -q "WSL2"
  if [[ $? == '0' ]]; then
    return 0 # Linux running nside wsl
  fi
  return 1 # Linux not running inside wsl
}

_service_running () {
  # 1st arg: name-of-service
  _SERVICE=$1
  RET=$(pgrep -f $_SERVICE)
  if [[ $? == '1' ]]; then
    return 1 # service not running
  fi
  return 0 # service running
}

_user_exist () {
  getent passwd $1 | grep -q $1
  if [[ $? -eq '1' ]]; then
    return 1 # user does not exist
  fi
  return 0 # user does exist
}

_file_exist () {
  _FILE=$1
  if [[ -f $_FILE ]]; then
      return 0 # file exist
  fi
  return 1 # file does not exist
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

_dir_empty () {
  if [ -d $1 ]; then
    if [ "$(ls -A $1)" ]; then
       return 1 # directory is not empty
     fi
     return 0 # directory is empty
  fi
  return 2 # directory does not exist
}

_is_cloned () {
  if [[ ! -d $1 ]]; then
    return 2 # dir does not exist
  fi
  if (ls -A $1 | grep -q -w ".git") ; then
    return 0 # dir is git repository
  fi
  return 1 # dir is not a git repository
}

_dir_can_clone () {
  if [[ ! -d $1 ]]; then
    return 0 # dir not exist -> can clone
  fi
  if [[ "$(ls -A $1)" ]]; then
   return 1 # dir not empty -> can not clone
 fi
 return 0  # dir empty -> can clone
}

# _is_nonempty () {
#   # returns:
#   # ..0 = directory is empty
#   # ..1 = directory is not empty
#   # ..2 = directory does not exist
#   if [ -d $1 ]; then
#     if [ "$(ls -A $1)" ]; then
#        return 0
#      fi
#      return 1
#   fi
#   return 1
# }

_ssh_github_validate () {
  # returns: 0 authenticated, 1 denied
  ssh -i $SSH_KEY -T git@github.com 2> /dev/null
  IS_AUTH=$? # 1 = authenticated, 255 = denied
  if [[ $IS_AUTH -eq '1' ]]
    then return 0; else return 1
  fi
}

_check_path () {
  # returns: 0 in $PATH, 1 not in $PATH
  echo $PATH | grep -q $1 || return 1
  return 0
}

_is_command () {
  # example usage: _is_command tutor && echo 'tutor exist'|| echo 'tutor does not exist'
  # returns: 0 command exist, 1 command does not exist
  if [[ -x "$(command -v $1)" ]]; then return 0; else return 1; fi
}

_in_group () {
  # 1st arg: groupname
  # returns: 0 in group, 1 not in group
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
