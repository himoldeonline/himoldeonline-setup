_info_display ""  "git auth"



# ..create new .gitconfig if the it does not exist
if ! _file_exist $GIT_CONFIG; then
  _banner "Create Git Configuration File"
  _info_display 'info' "No gitconfig file found"
  echo -e 'Creating gitconfig file'
  _add_gitconfig
fi

# ..create new ssh-key if the 'id_rsa_himoldeonline' ssh key does not exist
if ! _file_exist $SSH_KEY; then
  _banner "Generating SSH-Key"; _info_display 'info' 'No ssh-key found'
  _info_display 'info' 'Exporting the public key'; sleep 1
  _add_ssh_key $SSH_KEY && _print_ssh_pub || exit
  ssh-add $SSH_KEY
  _info_display 'info' \
    'Go to https://github.com/settings/ssh/new and add the above key then press enter to continue'
  read
fi

# ..validate our ssh-authentication
_banner 'Testing SSH-Authentication against Github'

if _ssh_github_validate; then
  _info_display 'info' 'Authenticated Successfully '; sleep 1
else
  _info_display 'error' 'Authentication Failed'; sleep 1
  _print_ssh_pub
  echo 'Make sure to add the above key to https://github.com/settings/ssh/new and re-run the script'
  exit
fi
