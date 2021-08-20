
_get_homebrew () {
  # this is the official install method grabbed from the homepage
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

_get_python () {
  brew install python
}

_get_tutor_dependencies () {
  brew install libyaml
}

_get_docker () {
  brew cask install docker;
}

_get_docker_compose () {
   brew install docker-compose
}
