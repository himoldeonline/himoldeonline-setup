# run git commands


_git_clone () {
  _START_DIRECTORY=$(pwd) # preserve the original woring directory
  if ! _service_running ssh-agent; then
    _is_command ssh-agent && eval "$(ssh-agent)" && ssh-add $SSH_KEY
  fi

  if ! _ssh_github_validate; then
    echo 'Can not authenticate against github.com'; return 1
  fi

  _run_git_clone () {
    _url=$1
    _dir=$2
    cd $_dir

    if _is_cloned $_dir; then
        echo -e "\033[0;32m$_dir is already cloned\e[0m\n"; return 0
    fi

    if ! _dir_can_clone $_dir; then
      echo -e "\033[0;31mCan not clone $_dir because directory is not empty\e[0m\n"; return 1
    fi

    echo -e "Cloning $_url -> \e[0;91m$_dir/\e[0m"
    git clone $_url $_dir && echo -e "\033[0;32mCloned $_url\e[0m\n" || echo -e "\033[0;31mCould not clone $_url\e[0m\n"
    sleep 0.5

  }


  # clone from all listed repositories
  _run_git_clone $GIT_URL_EDX_PLATFORM $EDX_PLATFORM_ROOT
  _run_git_clone $GIT_URL_OPENEDX_INSTRUCTIONS $INSTRUCTION_ROOT
  _run_git_clone $GIT_URL_OPENEDX_DEV $OPENEDX_DEV_ROOT
  _run_git_clone $GIT_URL_TIBETHEME $TIBE_THEME_ROOT
  _run_git_clone $GIT_URL_TUTOR $TUTOR_ROOT
  _run_git_clone $GIT_URL_SETUP $SETUP_ROOT
  _run_git_clone $GIT_URL_WEB_PORTAL $WEB_PORTAL_ROOT
  _run_git_clone $GIT_URL_PRACTICE $PRACTICE_ROOT


  _run_git_checkout_tags () {
    _tag=$1
    _dir=$2
    if ! _is_cloned $_dir; then
      echo -e "\033[0;31mCan not checkout tags because $_dir is not cloned\e[0m\n"
      return 1
    fi
    cd $_dir
    git fetch --all --tags  || return 1
    git checkout $_tag && echo -e "\033[0;32m$_tag checked out in $_dir\e[0m\n" || return 1
  }
  # checkout to correct tags
  _run_git_checkout_tags $TAG_EDX_PLATFORM $EDX_PLATFORM_ROOT || echo "Could not checkout $TAG_EDX_PLATFORM"

  _run_git_checkout_branch () {
    _branch=$1
    _dir=$2
    if ! _is_cloned $_dir; then
      echo -e "\033[0;31mCan not checkout branch because $_dir is not cloned\e[0m\n"
      return 1
    fi
    cd $_dir
    git checkout $_branch && echo -e "\033[0;32m$_branch checked out in $_dir\e[0m\n" || return 1
  }
  # checkout to correct branches
  _run_git_checkout_branch $BRANCH_OPENEDX_DEV $OPENEDX_DEV_ROOT || echo "Could not checkout $BRANCH_OPENEDX_DEV"

  cd $_START_DIRECTORY # go back to original directory
  return 0
}


_git_pull () {
  _START_DIRECTORY=$(pwd) # preserve the original woring directory
  if ! _service_running ssh-agent; then
    _is_command ssh-agent && eval "$(ssh-agent)" && ssh-add $SSH_KEY
  fi

  _run_git_pull () {

    # start git pull function for one repo at a time
    _url=$1
    _dir=$2
    cd $_dir

    __check () {
      # take string output and make a decission whether pull is possible or not
      git status | grep -q -i 'modified' && return 1
      git status | grep -q -i 'changes not staged' && return 1
      git status | grep -q -i 'changes to be committed' && return 1
      # if not making it passed this point, repository most likely have uncommited changes

      # last check to ensure clean working tree
      git status | grep -q -i 'nothing to commit, working tree clean' && return 0

      # if something went wrong, default to return code 1
      return 1
    }
    __confirm () {
      echo -e "\nGit pull from $_url"; sleep 0.5
      _yes_or_no && return 0 || return 1
    }

    if ! __confirm; then
      echo "Skip pulling $_ur"
      return 0
    fi
    if ! __check; then
      echo -e "\033[0;31mCould not do git pull because you have uncommited changes inside $_dir\e[0m\n"
      return 1
    fi

    # if all things pass, do git pull
    git pull && echo -e "\033[0;32mPulled down newest changes from $_url\e[0m\n"
    sleep 0.5

  }

  # pull from all listed repositories
  _run_git_pull $GIT_URL_OPENEDX_DEV $OPENEDX_DEV_ROOT
  _run_git_pull $GIT_URL_TIBETHEME $TIBE_THEME_ROOT
  _run_git_pull $GIT_URL_SETUP $SETUP_ROOT
  _run_git_pull $GIT_URL_OPENEDX_INSTRUCTIONS $INSTRUCTION_ROOT
  _run_git_pull $GIT_URL_WEB_PORTAL $WEB_PORTAL_ROOT
  _run_git_pull $GIT_URL_PRACTICE $PRACTICE_ROOT

  cd $_START_DIRECTORY # go back to original directory
  return 0
}
