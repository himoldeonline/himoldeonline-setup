
_get_homebrew () {
  # this is the official install method grabbed from the homepage
  echo 'Install Homebrew? [y/n]'
  read _c;
  if [[ $_c != 'y' ]]; then
    return 0
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo $SHELL | grep -w -q "zsh" && SHELL_TYPE="zsh" && echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/iselinaslaksen/.zprofile
  if _file_exist /opt/homebrew/bin/brew; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
  if _file_exist /etc/paths; then
    if _dir_exist /usr/local/bin; then
      sudo echo '/usr/local/bin/' >> /etc/paths
      export PATH=$PATH:/usr/local/bin/
    fi
  fi
  return 0
}

_get_tutor_dependencies () {
  echo 'Install lybyaml? [y/n]'
  read _c;
  if [[ $_c != 'y' ]]; then
    return 0
  fi
  brew install libyaml
}

_get_python () {
  echo 'Install Python? [y/n]'
  read _c
  if [[ $_c != 'y' ]]; then
    return 0
  fi
  brew install python
}

_get_docker () {
  echo 'Install Docker? [y/n]'
  read _c;
  if [[ $_c != 'y' ]]; then
    return 0
  fi
  brew install --cask docker && sleep 5 && open /Applications/Docker.app
  echo 'Complete the Docker installation in the GUI then press Enter to continue'; read
}
