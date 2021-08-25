# run git commands

_git_pull () {
  _START_DIRECTORY=$(pwd) # preserve the original woring directory


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

    __confirm || return 1
    __check || return 1

    # if all things pass, do git pull
    git pull || return 1
  }

  _feedback () {
    if [[ $1 -eq '0' ]]; then
      echo -e "\033[0;32mPulled down newest changes from $_url\e[0m\n"
    elif [[ $1 -eq '1' ]]; then
      echo -e "\033[0;31mCould not do git pull because you have uncommited changes inside $_dir\e[0m\n"
    fi
    sleep 0.5
  }

  # pull from all listed repositories
  _run_git_pull $GIT_URL_OPENEDX_DEV $OPENEDX_DEV_ROOT && _feedback '0' || _feedback '1'
  _run_git_pull $GIT_URL_TIBETHEME $TIBE_THEME_ROOT && _feedback '0' || _feedback '1'
  _run_git_pull $GIT_URL_SETUP $SETUP_ROOT && _feedback '0' || _feedback '1'
  _run_git_pull $GIT_URL_OPENEDX_INSTRUCTIONS $INSTRUCTION_ROOT && _feedback '0' || _feedback '1'
  _run_git_pull $GIT_URL_WEB_PORTAL $WEB_PORTAL_ROOT && _feedback '0' || _feedback '1'
  _run_git_pull $GIT_URL_PRACTICE $PRACTICE_ROOT && _feedback '0' || _feedback '1'

  cd $_START_DIRECTORY # go back to original directory
  return 0
}
