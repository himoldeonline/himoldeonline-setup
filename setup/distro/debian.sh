# Debian specific functions and variables

PACKAGES=(
	lsb-release curl  gpg  nano  git rsync openssh-client
	make build-essential libssl-dev zlib1g-dev tree
	libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncurses5-dev
	libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
	apt-transport-https ca-certificates gnupg libyaml-dev python3-dev libxml2-dev
	libxslt1-dev lib32z1-dev libjpeg-turbo8-dev
)


_update () {
	_info_installation "Updating System"
  sudo apt-get update &>> $_LOG_FILE && sudo apt-get upgrade -y  &>> $_LOG_FILE
  _info_ok "ok"
}

_install_packages () {

    _info_installation "The following packages will be installed:\n"
	for i in "${PACKAGES[@]}"; do
		dpkg -s $i &>>  $_LOG_FILE || _log_tail_exit
    if [[  $? -eq "1" ]]; then
      echo -e "\t\t\t$i"
      PACKAGES_TO_BE_INSTALLED=(${PACKAGES_TO_BE_INSTALLED[@]} "$i")
    fi
	done

  if [[  ${#PACKAGES_TO_BE_INSTALLED[@]} -eq 0 ]]; then
    echo -e "\t\t\tNo packages"
    return 0
  else
    _continue "\t\t"
  fi

  for i in "${PACKAGES_TO_BE_INSTALLED[@]}"
  do
		_info_installation $i
    sudo apt-get install -y $i &>> $_LOG_FILE || _log_tail_exit
    _info_ok "ok"
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
