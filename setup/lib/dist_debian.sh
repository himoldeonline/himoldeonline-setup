# Debian specific functions and variables



_has_package(){

  dpkg -s $1 > /dev/null 2>&1 &&  return 0 || echo return 1
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
  apt-get update && apt-get upgrade -y
}

_get_base_dep () {
  apt-get install -y \
    lsb-release curl gpg nano git sudo \
    rsync openssh-client python3 python3-pip \
    apt-transport-https \
    ca-certificates gnupg
}

_get_dep_tutor () {
  apt-get install -y \
    libyaml-dev
}

_get_dep_xblock_sdk() {
  apt-get install -y \
  python3-dev libxml2-dev libxslt-dev \
  lib32z1-dev libjpeg62-dev
}

_get_docker () {
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update && apt-get upgrade -y
  apt-get install docker-ce docker-ce-cli containerd.io -y
}