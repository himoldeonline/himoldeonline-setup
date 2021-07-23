

if [[ $DISTRO == *Fedora* ]]; then source ./scripts/setup/lib/dist_fedora.sh 
elif [[ $DISTRO == *Debian* ]]; then source ./scripts/setup/lib/dist_debian.sh 
elif [[ $DISTRO == *Ubuntu* ]]; then source ./scripts/setup/lib/dist_ubuntu.sh 
fi

_get_docker
_get_pyenv

