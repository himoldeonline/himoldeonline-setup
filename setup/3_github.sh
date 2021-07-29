# setup ssh-authentication @ github

_log_msg 'START 3_github.sh'


_info_validation 'SSH-Key \e[0;91m~/.ssh/id_rsa_himoldeonline\e[0m exist'
if _file_exist $SSH_KEY; then
  _info_ok "yes"
else
  _log_msg 'Generating SSH-Key'
  _sub_info "Generating SSH-Key"
  _add_ssh_key $SSH_KEY && _print_ssh_pub || exit 1
  _service_running ssh-agent && ssh-add $SSH_KEY &>> $_LOG_FILE
  _sub_info 'Login to your github account and go to https://github.com/settings/ssh/new and add the above key then press enter to continue'
  read
fi


_info_validation 'SSH-Authentication against Github'
if _ssh_github_validate; then
  _log_msg 'Authentication granted against Github'
  _info_ok "granted"
else
  _info_error 'failed'
  _log_msg 'Authentication failed against Github'
  _sub_info 'Printing out public ssh-key'
  _print_ssh_pub
  _abort 'Login to your github account and add the above key to https://github.com/settings/ssh/new and re-run the script'
fi

_log_msg 'END 3_github.sh'
