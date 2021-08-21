# System Configurations for Linux

_add_host () {
  # add ip and domain to hostfile
  IP=$1
  DOMAIN=$2
  # check if the domain and ip already exist
  cat /etc/hosts | grep $DOMAIN | grep -q $IP
  DOMAIN_EXIST=$?
  # append it does not exist
  if [[ $DOMAIN_EXIST == '1' ]]; then
    echo "$IP   $DOMAIN" | sudo tee -a /etc/hosts
  fi
}

_add_gitconfig () {
  # create .gitconfig if not present
    read -p 'alias/user: ' GIT_USER
    read -p 'email: ' GIT_EMAIL
    git config --global user.name $GIT_USER
    git config --global user.email $GIT_EMAIL
}

_add_ssh_key () {
  # 1st arg: /path/to/key
  ssh-keygen -t rsa -b 4096 -f $1 -q -N ""
}

_add_path_profile () {
  # 1st arg: path to be added in $PATH example: 'export PATH=~/.local/bin:$PATH'
  # 2nd arg: shell profile example: ~/.bashrc (NOTE: without qoutes)
  echo -e $1 >> $2
}

_add_user_to_group () {
  # add user to a group
  # 1st arg: username
  # 2nd arg: group-name
  sudo gpasswd -a $1 $2
}

_remove_user_from_group () {
  # remove user to a group
  # 1st arg: group-name
  # 2nd arg: username
  if command -v gpasswd &> /dev/null; then
    sudo gpasswd -d $2 $1 && return 0
  elif command -v dseditgroup &> /dev/null; then
    sudo dseditgroup -o edit -a $2 -t user $1 && return 0
  elif command -v dscl &> /dev/null; then
    sudo dscl . append /Groups/$1 GroupMembership $2 && return 0
  fi
}

_enable_service () {
  # enables and starts a service
  # 1st arg: name-of-service
  sudo systemctl enable $1 && sudo systemctl start $1
}

_append_to_profile () {
  # sets path for shell profile in $SH_PROFILE
  # returns:
  # ..1 = no shell profile found

  # macos does not follow the bash source convention, lets deal with that first
  _system=$(uname)
  if [[ $_system == Darwin ]]; then
    if [[ $SHELL == /bin/bash ]]; then
        if [[ -f ~/.bash_profile ]]; then
          cat ~/.bash_profile | grep -q -w "$1" || echo -e $1 >> ~/.bash_profile && return 0
        else
          echo -e $1 >> ~/.bash_profile && return 0
        fi

    elif [[ $SHELL == /bin/zsh ]]; then
      if [[ -f ~/.zprofile ]]; then
        cat ~/.zprofile | grep -q -w "$1" || echo -e $1 >> ~/.zprofile && return 0
      else
        echo -e $1 >> ~/.zprofile && return 0
      fi
    fi

  elif [[ $_system == Linux ]]; then

      # if .zshrc exist
      if [[ -f ~/.zshrc ]]; then
        cat ~/.zshrc | grep -q -w "$1" || echo -e $1 >> ~/.zshrc && return 0
      else
        # if .zshrc does not exist but default shell is zsh, then append
        echo $SHELL | grep -q -w zsh && echo -e $1 >> ~/.zshrc && return 0
      fi

      # if .bashrc exist
      if [[ -f ~/.bashrc ]]; then
        cat ~/.bashrc | grep -q -w "$1" || echo -e $1 >> ~/.bashrc && return 0
      else
        # if .bashrc does not exist but default shell is bash, then append
        echo $SHELL | grep -q -w bash && echo -e $1 >> ~/.bashrc && return 0
      fi

      # if ~/.profile exist
      if [[ -f ~/.profile ]]; then
        cat ~/.profile | grep -q -w "$1" || echo -e $1 >> ~/.profile && return 0
      fi

  fi
  return 1

}
