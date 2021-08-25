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
