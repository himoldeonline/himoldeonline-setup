# Fedora specific functions and variables

BASE_DEPENDENCIES=(
  nano git rsync openssh-clients curl gnupg2 gcc gcc-c++ python3 python3-pip
)

PYENV_DEPENDENCIES=(
  zlib-devel bzip2 bzip2-devel readline-devel sqlite
  sqlite-devel openssl-devel xz xz-devel libffi-devel
)

XBLOCK_SDK_DEPENDENCIES=(
  python-devel libxml2-devel libxslt-devel
  zlib-devel libjpeg-turbo-devel
)

TUTOR_DEPENDENCIES=(
  libyaml-devel
)

_update () {
	_info_installation "Updating System"
  sudo dnf update -y &>> $_LOG_FILE
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
  dnf list installed > _tmp

  for i in "${PACKAGES[@]}"; do
    cat _tmp | grep -w -q $i || PACKAGES_TO_BE_INSTALLED=(${PACKAGES_TO_BE_INSTALLED[@]} "$i")
  done
  rm _tmp
  unset PACKAGES
  if [[  ${#PACKAGES_TO_BE_INSTALLED[@]} -eq 0 ]]; then
    echo -e "\t\t\tNo packages"
    return 0
  fi

  _info_installation "The following $1 packages/dependencies will be installed:\n"
  for i in "${PACKAGES_TO_BE_INSTALLED[@]}"
  do
    echo -e "\t\t\t$i"
  done
  _continue "\t\t"

  for i in "${PACKAGES_TO_BE_INSTALLED[@]}"
  do
  	_info_installation $i
    sudo dnf install -y $i &>> $_LOG_FILE || _log_tail_exit
    _info_ok "ok"
  done
  unset PACKAGES_TO_BE_INSTALLED
}

_get_docker () {
  _info_installation 'Docker'
  _continue
  sudo dnf install dnf-plugins-core  -y &>> $_LOG_FILE || _log_tail_exit
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo &>> $_LOG_FILE || _log_tail_exit
  sudo dnf install -y docker-ce docker-ce-cli containerd.io &>> $_LOG_FILE || _log_tail_exit
}
