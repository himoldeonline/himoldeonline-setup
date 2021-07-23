  
# Fedora specific functions and variables

PACKAGES=(nano, git, rsync, openssh-clients, sudo,curl, pyenv, gnupg,python-devel, libxml2-devel, libxslt-devel, \
  zlib-devel, libjpeg-turbo-devel,libyaml-devel,docker)

PACKAGES_TO_BE_INSTALLED=""

_has_package(){
  dnf list installed | grep -w -q "$1" && return 0 || eco return 1
}

_check_packages_installed(){

  for i in "${PACKAGES}" 
  do
	_has_package $i  || PACKAGES_TO_BE_INSTALLED=(${PACKAGES_TO_BE_INSTALLED[@]} "$i")
  done

  echo $PACKAGES_TO_BE_INSTALLED
}


_update () {
  # ..updates all packages on your system
  dnf update -y
}

_get_base_dep () {
  dnf install -y \
  nano git rsync openssh-clients sudo \
  curl python3 python3-pip gnupg
}

_get_dep_tutor () {
  # ..for Tutor (tool to install/manage the Open edX platform)
  dnf install -y \
  libyaml-devel
}

_get_dep_xblock_sdk() {
  dnf install -y \
  python-devel libxml2-devel libxslt-devel \
  zlib-devel libjpeg-turbo-devel
}

_get_docker () {
  dnf install dnf-plugins-core  -y
  dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  dnf install -y docker-ce docker-ce-cli containerd.io
}