
_get_homebrew () {
  # this is the official install method grabbed from the homepage
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
  brew install libyaml
}

_get_python () {
  brew install python
}

_get_docker () {
  brew cask install docker
}
