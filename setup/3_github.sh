# setup ssh-authentication @ github

_info_validation 'SSH-Key \e[0;91m~/.ssh/id_rsa_himoldeonline\e[0m exist'
if _file_exist $SSH_KEY; then
  _info_ok
else
  _sub_info "Generating SSH-Key"
  _add_ssh_key $SSH_KEY && _print_ssh_pub || exit
  ssh-add $SSH_KEY
  _sub_info  \
    'Go to https://github.com/settings/ssh/new and add the above key then press enter to continue'
  read
fi

_info_validation 'SSH-Authentication against Github'
if _ssh_github_validate; then
  _info_ok
else
  _info_error 'Authentication Failed'
  _print_ssh_pub
  _abort 'Make sure to add the above key to https://github.com/settings/ssh/new and re-run the script'
fi
