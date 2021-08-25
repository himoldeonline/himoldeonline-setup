# open files and urls in your default file/url handler

_web_browser_open () {
  _PLATFORM=$(uname)

  if [[ $_PLATFORM == Linux ]]; then
    if which xdg-open > /dev/null; then
      xdg-open $1 && return 0
    elif which gnome-open > /dev/null; then
      gnome-open $1 && return 0
    fi

  elif [[ $_PLATFORM == Darwin ]]; then
    open -a /Applications/Safari.app $1 && return 0
  fi
  echo 'Can not find a web browser'
  return 1
}


_vs_code_open () {
  _dir=$1
  if ! _is_command code; then
    echo 'Could not find VS-Code in $PATH'
    if [[ $_PLATFORM == Darwin ]]; then
      echo 'This can be fixed by opening VS-Code'
      echo 'Then open the Command Palette (View -> Command Palette)'
      echo 'Type shell command to find Shell Command: Install 'code' command in PATH command'
      echo 'Then re-try this option'
      echo -e 'You can read more about this here\nhttps://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line'
    else
      echo 'Is VS-Code installed?'
    fi
  else
    cd $_dir
    code .
    cd $HOME
  fi
}
