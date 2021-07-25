# Fedora specific functions and variables

PACKAGES=(
  nano git rsync openssh-clients curl gnupg python-devel libxml2-devel libxslt-devel
  zlib-devel libjpeg-turbo-devel libyaml-devel zlib-devel bzip2 bzip2-devel readline-devel sqlite
  sqlite-devel openssl-devel xz xz-devel libffi-devel
)

PACKAGES_TO_BE_INSTALLED=""

_update () {
	_sub_info  "Updating System"
  sudo dnf update -y
}

_install_packages () {
  _INST_LIST=$(dnf list installed)

  for i in "${PACKAGES[@]}"; do
    dnf list installed $i &> /dev/null || PACKAGES_TO_BE_INSTALLED=(${PACKAGES_TO_BE_INSTALLED[@]} "$i")
  done

  for i in "${PACKAGES_TO_BE_INSTALLED[@]}"
  do
  	_info_installation $i
    # _continue
    sudo dnf install -y $i 1> /dev/null 2> .setup.log ||_log_tail_exit
  done
}

_get_docker () {
  if ! _has_command docker; then
    _info_installation 'Docker'
    _continue
    dnf install dnf-plugins-core  -y  1> /dev/null 2> .setup.log || _log_tail_exit
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo  1> /dev/null 2> .setup.log || _log_tail_exit
    dnf install -y docker-ce docker-ce-cli containerd.io  1> /dev/null 2> .setup.log || _log_tail_exit
  fi
}
