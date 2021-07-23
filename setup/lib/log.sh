# logging functions

_log_output () {
    _set_color 94m
    echo ''
    #BOX="${HUE_START}[info]${HUE_END}"
    printf  "${HUE_START}\t\t$1${HUE_END}\n"
}

_log_init () {
  _L='###############################'
  _TIME=$(date +"%Y-%m-%d %H:%M:%S")
  echo -e "$_L\n##### $_TIME #####\n$_L" >> $_LOG_FILE 2>&1
}

_log_command () {
  # arg 1: command inside double qoutes -> example: "sudo apt update"
  _TIME=$(date +"%Y-%m-%d %H:%M:%S")
  _CMD=$1
  echo -e "\nTime: $_TIME" >> $_LOG_FILE 2>&1
  eval $_CMD >> $_LOG_FILE 2>&1 ||
    _log_output "Reading Log: $_LOG_FILE \n\nSTART\n`\
    grep -rn  -A 100 "$_TIME" $_LOG_FILE`\nEND\n\n"
}

_log_msg () {
  # arg 1: message to log
  _TIME=$(date +"%Y-%m-%d %H:%M:%S")
  _MSG=$1
  echo -e "\nTime: $_TIME" >> $_LOG_FILE 2>&1
  echo -e "$_MSG" >> $_LOG_FILE 2>&1
}

_log_error () {
  _TIME=$(date +"%Y-%m-%d %H:%M:%S")
  _MSG=$1
  echo -e "\nTime: $_TIME" >> $_LOG_FILE 2>&1
  echo -e "$_MSG" >> $_LOG_FILE 2>&1
  _log_output "Reading Log: $_LOG_FILE \n\nSTART\n`\
  grep -rn  -A 100 "$_TIME" $_LOG_FILE`\nEND\n\n"
  exit 1
}

_log_remove () {
  rm $_LOG_FILE
}
