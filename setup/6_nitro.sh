# For when running multiple nitro commands

_log_msg 'START 6_tutor.sh'

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
  checkPlatform || _log_tail_exit

  _log_msg 'Finding the latest nitro version'
  version=$(curl -s https://api.github.com/repos/craftcms/nitro/releases | grep -i -m 1 tag_name | head -1 | sed 's/\("tag_name": "\(.*\)",\)/\2/' | tr -d '[:space:]')
  if [ ! "$version" ]; then
    _log_msg 'Could not get the latest nitro version'
    _log_tail_exit
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
        _log_tail_exit
      fi
    fi
  }

  targetTempFolder="$HOME/himoldeonline/temp_nitro_extract"
  mkdir -p "$targetTempFolder"

  fileName=nitro$DOWNLOAD_SUFFIX$DOWNLOAD_ARCH$DOWNLOAD_ZIP_EXTENSION
  packageUrl=https://github.com/craftcms/nitro/releases/download/$version/"$fileName"
  targetZipFile="$targetTempFolder/$fileName"

  _log_msg "Downloading package $packageUrl to $targetZipFile"
  curl -sSL "$packageUrl" --output "$targetZipFile" || _log_tail_exit

  _log_msg "Extracting $targetZipFile downloaded nitro tarball to $targetTempFolder"
  tar xzf "$targetZipFile" -C "$targetTempFolder" || _log_tail_exit

  _log_msg 'Running checksum to validate integrity of downloaded files'
  checkHash "$targetZipFile" "$version" "$targetTempFolder" "$fileName" || _log_tail_exit

  _log_msg 'Make nitro it executable'
  chmod +x "$targetTempFolder/nitro" || _log_tail_exit

  _log_msg 'Moving nitro executable to final location'
  sudo mv "$targetTempFolder/nitro" "/usr/local/bin/nitro" || _log_tail_exit

  _log_msg "Removing $targetTempFolder"
  rm -rf "$targetTempFolder"
}

if ! _is_command nitro; then
  _log_msg 'Installing nitro'
  _info_installation "nitro\n"
  _install_nitro
fi

_nitro_init_environment () {
  _yes_or_no "Run the Nitro init command" || eval '_info_ok "skipping" && return 0'
  _log_msg 'Running nitro init'
  sg docker -c "nitro init"
}
_nitro_init_environment

_nitro_add_portal () {
  _yes_or_no "Add our website Portal to nitro" || eval '_info_ok "skipping" && return 0'
  _log_msg 'Adding our Craft CMS platform Portal'
  sg docker -c "nitro add $HOME/himoldeonline/craft_web_portal_source/portal/"
}
_nitro_add_portal




_log_msg 'END 6_nitro.sh'
