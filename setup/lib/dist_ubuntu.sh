# Ubuntu specific functions and variables



PACKAGES=( lsb-release curl  gpg  nano  git sudo rsync openssh-client \
make build-essential libssl-dev zlib1g-dev tree \
libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev \
libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl \
apt-transport-https ca-certificates gnupg libyaml-dev python3-dev libxml2-dev  libxslt1-dev lib32z1-dev libjpeg-turbo8-dev)



_has_package(){

  dpkg -s $1 > /dev/null 2>&1 &&  return 0 ||  return 1
}

_check_packages_installed(){
  for i in "${PACKAGES[@]}"; do 
	_has_package $i  || PACKAGES_TO_BE_INSTALLED+=("$i")
 
  done
  
}

_install_packages()
{
  
    
  for i in "${PACKAGES_TO_BE_INSTALLED[@]}"; do 
	_sub_info  "Installing $i"
  sudo apt-get install -y $i > /dev/null
  done
}

_update () {
  # ..updates all packages on your system
	_sub_info  "Updating packages..."
 sudo apt-get update > /dev/null && sudo apt-get upgrade -y  > /dev/null
}





_get_docker () {
  if ! _has_command docker
  then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    #sudo apt-get update
    sudo apt-get install -y \
    docker-ce docker-ce-cli containerd.io -y
    fi
}

 