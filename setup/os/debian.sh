# Debian specific functions and variables

BASE_DEPENDENCIES=(
	lsb-release curl  gpg  nano  git rsync openssh-client
	tree apt-transport-https ca-certificates gnupg python3 python3-pip
)

PYENV_DEPENDENCIES=(
	make build-essential libssl-dev zlib1g-dev
	libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev
	libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
)

XBLOCK_SDK_DEPENDENCIES=(
	python3-dev libxml2-dev libxslt1-dev
	lib32z1-dev libjpeg-turbo8-dev
)

TUTOR_DEPENDENCIES=(
	libyaml-dev
)

_update () {
	_info_installation "Updating System"
  sudo apt-get update &>> $_LOG_FILE && sudo apt-get upgrade -y  &>> $_LOG_FILE
  _info_ok "ok"
}

_install_packages () {
	if [[ $1 == 'base' ]]; then
	  PACKAGES=("${BASE_DEPENDENCIES[@]}")
	elif [[ $1 == 'tutor' ]]; then
	  PACKAGES=("${TUTOR_DEPENDENCIES[@]}")
	elif [[ $1 == 'pyenv' ]]; then
	  PACKAGES=("${PYENV_DEPENDENCIES[@]}")
	elif [[ $1 == 'xblock_sdk' ]]; then
	  PACKAGES=("${XBLOCK_SDK_DEPENDENCIES[@]}")
	fi

	for i in "${PACKAGES[@]}"; do
		dpkg -s $i &>> $_LOG_FILE
	  if [[  $? -eq "1" ]]; then
	    PACKAGES_TO_BE_INSTALLED=(${PACKAGES_TO_BE_INSTALLED[@]} "$i")
	  fi
	done
	unset PACKAGES

	if [[  ${#PACKAGES_TO_BE_INSTALLED[@]} -eq 0 ]]; then
		_log_msg "All packages already installed for $1"
	  return 0
	fi

	_info_installation "The following $1 packages/dependencies is needed:\n"
	for i in "${PACKAGES_TO_BE_INSTALLED[@]}"
	do
	  echo -e "\t\t\t$i"
	done
	echo 'Install Listed Packages? [y/n]'
	read _c
  if [[ $_c != 'y' ]]; then
		echo 'Skip installing'
		return 0
	fi
	for i in "${PACKAGES_TO_BE_INSTALLED[@]}"
	do
		_info_installation $i
	  sudo apt-get install -y $i &>> $_LOG_FILE || _log_tail_exit
	  _info_ok "ok"
	done
	unset PACKAGES_TO_BE_INSTALLED
}

_get_docker () {
	_info_installation 'Docker'
  _continue
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update &>> $_LOG_FILE && sudo apt-get install -y docker-ce docker-ce-cli containerd.io &>> $_LOG_FILE || _log_tail_exit
}
