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
  ssh-keygen -t rsa -b 4096 -f $1
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
  sudo usermod -aG $2 $1
}

_remove_user_from_group () {
  # remove user to a group
  # 1st arg: group-name
  # 2nd arg: username
  sudo gpasswd -d $2 $1
}

_add_service () {
  # enables and starts a service
  # 1st arg: name-of-service
  sudo systemctl enable $1 && sudo systemctl start $1
}

_append_to_profile () {
  # sets path for shell profile in $SH_PROFILE
  # returns:
  # ..1 = no shell profile found
  if [[ -f ~/.zshrc ]]; then
    echo -e $1 >> ~/.zshrc
  fi
  
  if [[ -f ~/.bashrc ]]; then    
    echo -e $1 >> ~/.bashrc
  fi

}