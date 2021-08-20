# for displaying information in various ways

_banner () {
  # 1st arg: title message "inside double qoutes"
  sleep 0.5 && clear
  echo -e "$1"
}

_list_options () {
  # Prints out options from passed arguments
  # Takes an arbitrary amount of args, they will all be printed on separate lines
  echo -e '\n----------------------------------------------'
  for optn in "$@"; do
    echo -e "$optn"
  done
  echo -e '----------------------------------------------\n'
}


_yes_or_no () {
  _M='Continue'
  if [[ $# -eq 1 ]]; then _M=$1; fi
  _sub_info "$_M"
  echo -e '\n----------------------------------------------'
  echo -e '(Y) yes\n\t(N) no'
  echo -e '----------------------------------------------\n'
  read _CNTNUE
  _line_overwrite
  if [[ $_CNTNUE == 'y' ]]; then return 0; fi
  return 1
}
