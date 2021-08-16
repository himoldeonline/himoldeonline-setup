# nitro installation and nitro commands

_install_nitro () {
  # this is a modified version of nitros official installation script
  # the script was fetched from here: http://installer.getnitro.sh
  # and is documented here: https://craftcms.com/docs/nitro/2.x/installation.html
  export TEMP_FOLDER="$HOME/himoldeonline/temp_nitro_extract"
  export DOWNLOAD_SUFFIX=""
  export DOWNLOAD_ARCH=""
  export DOWNLOAD_ZIP_EXTENSION=".tar.gz"
  export EXECUTABLE_NAME="nitro"

  function checkPlatform {
    DOWNLOAD_SUFFIX="_linux"
    arch=$(uname -m)
    case $arch in
    "x86_64")
      DOWNLOAD_ARCH="_x86_64"
      ;;
    "aarch64")
      DOWNLOAD_ARCH="_aarch64"
      ;;
    "arm64")
      DOWNLOAD_ARCH="_arm64"
      ;;
    *)
      ;;
    esac
  }
  _log_msg 'Finding cpu architecture'
  checkPlatform || exit 1

  _log_msg 'Finding the latest nitro version'
  version=$(curl -s https://api.github.com/repos/craftcms/nitro/releases | grep -i -m 1 tag_name | head -1 | sed 's/\("tag_name": "\(.*\)",\)/\2/' | tr -d '[:space:]')
  if [ ! "$version" ]; then
    _log_msg 'Could not get the latest nitro version'
    exit 1
  fi

  function checkHash {
    sha_cmd="sha256sum"
    fileName=nitro_$2_checksums.txt
    filePath="$HOME/himoldeonline/temp_nitro_extract/$fileName"
    checksumUrl=https://github.com/craftcms/nitro/releases/download/$version/$fileName
    targetFile=$3/$fileName

    if [ -x "$(command -v $shaCmd)" ]; then
      # download the checksum file.
      (curl -sLS "$checksumUrl" --output "$targetFile")
      # Run the sha command against the zip and grab the hash from the first segment.
      zipHash="$($shaCmd "$1" | cut -d' ' -f1 | tr -d '[:space:]')"
      # See if the checksum we calculated matches a result in the checksum file.
      checkResultFileName=$(sed -n "s/^$zipHash  //p" "$filePath")
      # don't need this anymore
      rm "$filePath"
      # Make sure the file names match up.
      if [ "$4" != "$checkResultFileName" ]; then
        rm "$1"
        _log_msg "Checksums do not checkout for $filePath"
        exit 1
      fi
    fi
  }

  targetTempFolder="$HOME/himoldeonline/temp_nitro_extract"
  mkdir -p "$targetTempFolder"

  fileName=nitro$DOWNLOAD_SUFFIX$DOWNLOAD_ARCH$DOWNLOAD_ZIP_EXTENSION
  packageUrl=https://github.com/craftcms/nitro/releases/download/$version/"$fileName"
  targetZipFile="$targetTempFolder/$fileName"

  _log_msg "Downloading package $packageUrl to $targetZipFile"
  curl -sSL "$packageUrl" --output "$targetZipFile" || exit 1

  _log_msg "Extracting $targetZipFile downloaded nitro tarball to $targetTempFolder"
  tar xzf "$targetZipFile" -C "$targetTempFolder" || exit 1

  _log_msg 'Running checksum to validate integrity of downloaded files'
  checkHash "$targetZipFile" "$version" "$targetTempFolder" "$fileName" || exit 1

  _log_msg 'Make nitro it executable'
  chmod +x "$targetTempFolder/nitro" || exit 1

  _log_msg 'Moving nitro executable to final location'
  sudo mv "$targetTempFolder/nitro" "/usr/local/bin/nitro" || exit 1

  _log_msg "Removing $targetTempFolder"
  rm -rf "$targetTempFolder"
  echo 'Done'
}



_nitro_init_environment () {
  _yes_or_no "Run the Nitro init command" || eval '_info_ok "skipping" && return 0'
  _log_msg 'Running nitro init'
  echo -e 'We currently use these images:\nMySQL Ver. 8\nRedis'
  nitro init
}


_nitro_add_himoldeonline_portal () {
  _yes_or_no "Add our website Portal to nitro" || eval '_info_ok "skipping" && return 0'
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
  _yes_or_no "Run composer install on $WEB_PORTAL_ROOT" || eval '_info_ok "skipping" && return 0'
  export __cwd=$(pwd)
  cd $WEB_PORTAL_ROOT
  nitro composer install
  cd $__cwd
  unset __cwd
}


_nitro_portal_db_import () {
  _yes_or_no "Import database for $WEB_PORTAL_ROOT" || eval '_info_ok "skipping" && return 0'
  export __cwd=$(pwd)
  cd $WEB_PORTAL_ROOT
  _log_msg "Importing $WEB_PORTAL_ROOT/db/portal.sql"
  nitro db import db/portal.sql
  cd $_START_DIRECTORY
}
