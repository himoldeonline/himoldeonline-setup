# nitro installation and nitro commands

function _install_nitro () {
  # this is a modified version of nitros official installation script
  # the script was fetched from here: http://installer.getnitro.sh
  # and is documented here: https://craftcms.com/docs/nitro/2.x/installation.html
  export TEMP_FOLDER="$HOME/himoldeonline/temp_nitro_extract"
  export FINAL_DIR_LOCATION="/usr/local/bin"
  export FINAL_BINARY_LOCATION="/usr/local/bin/nitro"
  export DOWNLOAD_ZIP_EXTENSION=".tar.gz"
  export EXECUTABLE_NAME="nitro"


  _log_msg 'Getting platform and cpu architecture'
  uname=$(uname)
  if [[ $uname == Darwin ]]; then DOWNLOAD_SUFFIX="_darwin"
  elif [[ $uname == Linux ]]; then DOWNLOAD_SUFFIX="_linux"
  fi

  arch=$(uname -m)
  if [[ $arch == x86_64 ]]; then DOWNLOAD_ARCH="_x86_64"
  elif [[ $arch == aarch64 ]]; then DOWNLOAD_ARCH="_aarch64"
  elif [[ $arch == arm64 ]]; then DOWNLOAD_ARCH="_arm64"
  fi


  _log_msg 'Getting the latest nitro version'
  _URL_NITRO_RELEASES=https://api.github.com/repos/craftcms/nitro/releases
  version=$(curl -s $_URL_NITRO_RELEASES | grep -i -m 1 tag_name | head -1 | sed 's/\("tag_name": "\(.*\)",\)/\2/' | tr -d '[:space:]')

  if [[ ! "$version" ]]; then
    _log_msg 'Could not get the latest nitro version'; _log_tail_exit
  fi

  function checkHash {

    _URL_NITRO_RELEASES_CHECKSUMS=https://github.com/craftcms/nitro/releases/download
    fileName=nitro_$2_checksums.txt
    filePath="$HOME/himoldeonline/temp_nitro_extract/$fileName"
    checksumUrl="$_URL_NITRO_RELEASES_CHECKSUMS"/"$version"/"$fileName"
    targetFile=$3/$fileName
    if _is_command sha256sum; then
      sha_cmd="sha256sum"
    else
      shaCmd="shasum -a 256"
    fi

    if [[ -x "$(command -v $shaCmd)" ]]; then
      # download the checksum file.
      (curl -sLS "$checksumUrl" --output "$targetFile")
      # Run the sha command against the zip and grab the hash from the first segment.
      zipHash="$($shaCmd "$1" | cut -d' ' -f1 | tr -d '[:space:]')"
      # See if the file we calculated matches a result in the checksum file.
      checkResultFileName=$(sed -n "s/^$zipHash  //p" "$filePath")
      # Make sure the file names match up.
      if [[ "$4" != "$checkResultFileName" ]]; then
        rm "$1"; _log_error "Checksums do not checkout for $1"
      fi
      # don't need this anymore
      rm "$filePath"
    fi
  }


  targetTempFolder="$HOME/himoldeonline/temp_nitro_extract"
  mkdir -p "$targetTempFolder" && _log_msg "Creating $targetTempFolder"

  fileName=nitro$DOWNLOAD_SUFFIX$DOWNLOAD_ARCH$DOWNLOAD_ZIP_EXTENSION
  packageUrl=https://github.com/craftcms/nitro/releases/download/$version/"$fileName"
  targetZipFile="$targetTempFolder/$fileName"

  _log_msg "Downloading package $packageUrl to $targetZipFile"
  curl -sSL "$packageUrl" --output "$targetZipFile" ||
    _log_error "Could not download $targetZipFile from $packageUrl"

  _log_msg "Extracting $targetZipFile downloaded nitro tarball to $targetTempFolder"
  tar xzf "$targetZipFile" -C "$targetTempFolder"

  _log_msg "Running checksum to validate integrity of $targetZipFile files"
  checkHash "$targetZipFile" "$version" "$targetTempFolder" "$fileName"

  _log_msg "Making $targetTempFolder"/"$EXECUTABLE_NAME executable"
  chmod +x "$targetTempFolder"/"$EXECUTABLE_NAME" || _log_tail_exit

  if ! _dir_exist $FINAL_DIR_LOCATION; then
    sudo mkdir -p $FINAL_DIR_LOCATION && _log_msg "Creating directory $FINAL_DIR_LOCATION"
  fi

  _log_msg "Moving $targetTempFolder/$EXECUTABLE_NAME to $FINAL_BINARY_LOCATION"
  sudo mv "$targetTempFolder"/"$EXECUTABLE_NAME" "$FINAL_BINARY_LOCATION" ||
    _log_error "Could not move $targetTempFolder/nitro to $FINAL_BINARY_LOCATION"

  # clean up
  rm -rf "$targetTempFolder" && _log_msg "Removing $targetTempFolder"

  _log_msg "Nitro $version has been installed to $FINAL_DIR_LOCATION"

  echo "Nitro $version has been installed to $FINAL_DIR_LOCATION"
}


_nitro_init_environment () {
  _yes_or_no "Run the Nitro init command" || return 0
  _log_msg 'Running nitro init'
  echo -e 'We currently use these images:\nMySQL Ver. 8\nRedis'
  nitro init
}


_nitro_add_himoldeonline_portal () {
  _yes_or_no "Add our website Portal to nitro" || return 0
  export __cwd=$(pwd)
  cd $WEB_PORTAL_ROOT
  _log_msg 'Adding our Craft CMS platform Portal'
  echo "Make sure to type yes to all and name the database 'portal'"
  nitro add
  cp ./.env.example ./env
  cd $__cwd
  unset __cwd
}


_nitro_portal_composer_install () {
  _yes_or_no "Run composer install on $WEB_PORTAL_ROOT" || return 0
  export __cwd=$(pwd)
  cd $WEB_PORTAL_ROOT
  mv composer.lock composer.lock_bak
  nitro composer install
  cd $__cwd
  unset __cwd
}


_nitro_portal_db_import () {
  _yes_or_no "Import database for $WEB_PORTAL_ROOT" || return 0
  export __cwd=$(pwd)
  cd $WEB_PORTAL_ROOT
  _log_msg "Importing $WEB_PORTAL_ROOT/db/portal.sql"
  nitro db import db/portal.sql
  cd $_START_DIRECTORY
}
