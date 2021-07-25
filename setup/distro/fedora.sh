# Fedora specific functions and variables

PACKAGES=(
  nano git rsync openssh-clients curl gnupg2 python3-devel libxml2-devel libxslt-devel
  zlib-devel libjpeg-turbo-devel libyaml-devel zlib-devel bzip2 bzip2-devel readline-devel sqlite
  sqlite-devel openssl-devel xz xz-devel libffi-devel
)

_update () {
	_info_installation "Updating System"
  sudo dnf update -y
  _info_ok "ok"
}

_install_packages () {

  dnf list installed > _tmp

  for i in "${PACKAGES[@]}"; do
    while read -r _installed; do
       echo $_installed | grep -w -q $i || PACKAGES_TO_BE_INSTALLED=(${PACKAGES_TO_BE_INSTALLED[@]} "$i")
    done < _tmp

  done
  rm _tmp

  if [[  ${#PACKAGES_TO_BE_INSTALLED[@]} -eq 0 ]]; then
    echo -e "\t\t\tNo packages"
    return 0
  fi

  _continue "\t\t"

  for i in "${PACKAGES_TO_BE_INSTALLED[@]}"
  do
  	_info_installation $i
    sudo dnf install -y $i || exit
  done
}

_get_docker () {
  if ! _has_command docker; then
    _info_installation 'Docker'
    _continue
    dnf install dnf-plugins-core  -y  || exit
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo  || exit
    dnf install -y docker-ce docker-ce-cli containerd.io || exit
  fi
}
