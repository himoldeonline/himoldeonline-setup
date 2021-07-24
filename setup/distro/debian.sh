# Debian specific functions and variables

PACKAGES=(
	lsb-release curl  gpg  nano  git rsync openssh-client
	make build-essential libssl-dev zlib1g-dev tree
	libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev
	libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
	apt-transport-https ca-certificates gnupg libyaml-dev python3-dev libxml2-dev
	libxslt1-dev lib32z1-dev libjpeg-turbo8-dev
)

PACKAGES_TO_BE_INSTALLED=""
_update () {
	_sub_info  "Updating System"
  sudo apt-get update > /dev/null && sudo apt-get upgrade -y  > /dev/null
}

_install_packages () {
	for i in "${PACKAGES[@]}"; do
  	dpkg -s $1 > /dev/null 2>&1 || PACKAGES_TO_BE_INSTALLED+=("$i")
  done

  for i in "${PACKAGES_TO_BE_INSTALLED[@]}"
  do
		_info_installation $i
    _continue
    sudo apt-get install -y $i 1> /dev/null 2> .setup.log || _log_tail_exit
  done
}

_get_docker () {
  if ! _has_command docker; then
		_info_installation 'Docker'
    _continue
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt-get install -y docker-ce docker-ce-cli containerd.io  1> /dev/null 2> .setup.log || _log_tail_exit
  fi
}
