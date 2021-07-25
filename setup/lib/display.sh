# pretty printing text in terminal

_set_color (){
  HUE_START="\e[0;$1"
  HUE_END='\e[0m'
}

_abort () {
  _set_color 31m
  BOX="${HUE_START}[exit]${HUE_END}"
  echo -e "${BOX}\t$1"
  exit 1
}

_sub_info () {
  _set_color 32m
  echo -e -n "${HUE_START}\t$1${HUE_END}"
}

_info_ok () {
  _set_color 32m
  echo -e  "${HUE_START}\t[$1]${HUE_END}"
  sleep 0.5
}

_info_error () {
  _set_color 31m
  BOX="${HUE_START}[error]${HUE_END}"
  echo -e  "\t${BOX}\t\t$1"
  sleep 0.5
}

_info_validation () {
  _set_color 35m
  BOX="${HUE_START}[validation]${HUE_END}"
  echo -e -n  "\t${BOX}\t$1"
  sleep 0.5
}

_info_installation () {
  _set_color 35m
  BOX="${HUE_START}[Installing]${HUE_END}"
  echo -e -n "\t${BOX}\t$1"
}

_info_cloning () {
  _set_color 96m
  BOX="${HUE_START}[Cloning]${HUE_END}"
  echo -e "\t${BOX}\t$1"
}

_header () {
  # 1st arg: title message (inside double qoutes)
  echo -e "\033[0;93m\n### $1 ###\n\033[0m"
}

_banner () {
  # 1st arg: title message "inside double qoutes"
  sleep 0.5 && clear
  echo -e "\n\t\033[0;32m$1\033[0m\n"
}



_list_options () {
  # Prints out options loaded from arguments
  # Takes an arbitrary amount of args, they will all be printed on separate lines
  echo -e '\n\t\t----------------------------------------------'
  for optn in "$@"
  do
    echo -e "\t\t$optn"
  done
  echo -e '\t\t----------------------------------------------\n'
}

_line_overwrite () {
  _set_color 32m
  echo -e "\e[1A\e[K\e[1A\e[K\t${HUE_START}$1${HUE_END}"
}

_continue (){
  _M=''
  if [[ $# -eq 1 ]]; then _M=$1; fi
  __M=$_M"Continue"
  #_sub_info "$_M"
  echo -e -n "\033[0;32m\t$__M? (Y)es/\033[0m\033[0;31m(N)o \033[0m"
  read _CNTNUE
  #_line_overwrite
  if [[ $_CNTNUE != 'y' ]]; then exit; fi

}

_continue2 () {
  _M='Continue'
  if [[ $# -eq 1 ]]; then _M=$1; fi
  _sub_info "$_M"
  echo -e '\t\t----------------------------------------------'
  echo -e '\033[0;32m\t\t(Y) yes\033[0m\n\033[0;31m\t\t(N) no\033[0m'
  echo -e '\t\t----------------------------------------------\n'
  read _CNTNUE
  _line_overwrite
  if [[ $_CNTNUE != 'y' ]]; then exit; fi
}
