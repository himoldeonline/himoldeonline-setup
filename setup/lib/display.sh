#!/bin/bash



_set_color (){
    HUE_START="\e[0;$1"
    HUE_END='\e[0m'
    
}


_abort () {
    _set_color 31m
    BOX="${HUE_START}[exit]${HUE_END}"
    printf  "${BOX}\t$1"
    exit
}


_sub_info () {
    _set_color 32m
    #BOX="${HUE_START}[info]${HUE_END}"
    printf  "${HUE_START}\n\t$1${HUE_END}" 
}

_validation () {
    _set_color 35m
    BOX="${HUE_START}[validation]${HUE_END}"
    printf   "${BOX}\t$1" 
}


_passed () {
    _set_color 33m
    BOX="${HUE_START}[validation]${HUE_END}"
    printf  "${HUE_START}\tpassed${HUE_END}\n" 
}


_info_display () {
  # ..1st arg(level of warning): 'info', 'warning' or 'error'
  # ..2nd arg: message

  if [[ $1 == 'error' ]]; then
    HUE_START='\e[0;31m'
    HUE_END='\e[0m'
    BOX="${HUE_START}[$1]${HUE_END}"
  fi
  if [[ $1 == 'warning' ]]; then
    HUE_START='\e[0;33m'
    HUE_END='\e[0m'
    BOX="${HUE_START}[$1]${HUE_END}"
  fi
    echo -e -n "${BOX}\t$2"
  
}

_header () {
  # 1st arg: title message (inside double qoutes)
  HUE_START='\033[0;32m'
  HUE_END='\033[0m'
  BOX="${HUE_START}$1\n${HUE_END}"
  echo -e "$BOX"
}


_banner () {
  # 1st arg: title message "inside double qoutes"
  sleep 0.5 && clear
  HUE_START='\033[0;32m'
  HUE_END='\033[0m'
  BOX="${HUE_START}\n\n\t$1\n${HUE_END}"
  echo -e "\n\n\t$BOX\n"
}


_list_options () {
  # Prints out options loaded from arguments
  # Takes an arbitrary amount of args, they will all be printed on separate lines
  echo -e '\n\t----------------------------------------------'
  for optn in "$@"
  do
    echo -e "\t$optn"
  done
  echo -e '\t----------------------------------------------\n'
}

_line_overwrite () {
  _set_color 32m
  echo -e "\e[1A\e[K\e[1A\e[K\t${HUE_START}$1${HUE_END}"
}


_continue () {
  M='Continue?'
  if [[ $# -eq 1 ]]; then M=$1; fi
  _sub_info "$M";
  echo -e '\n\t----------------------------------------------'
  echo -e '\033[0;32m\t(Y) yes\033[0m\n\033[0;31m\t(N) no\033[0m'
  echo -e '\t----------------------------------------------'
  read _CNTNUE; if [[ $_CNTNUE == 'n' ]]; then exit; fi
}