#!/usr/bin/env bash

echo '::group::Downloading yq'

set -e

_base_url='https://github.com/mikefarah/yq/releases/download/'

_os=
_arch=

_bin_name=
_dl_name=
_dl_path=
_dl_url=

case $RUNNER_OS in
  Linux)
    _os='linux'
    ;;
  macOS)
    _os='darwin'
    ;;

  *)
    echo "Cannot handle OS of type $RUNNER_OS"
    echo "Expected one of: [ Linux macOS ]"
    exit 1
    ;;
esac

case $RUNNER_ARCH in
  'X86')
    _arch='386'
    ;;
  'X64')
    _arch='amd64'
    ;;
  'ARM')
    _arch='arm'
    ;;
  'ARM64')
    _arch='arm64'
    ;;

  *)
    echo "Cannot handle Arch of type $RUNNER_ARCH"
    echo "Expected one of: [ X86 X64 ARM ARM64 ]"
    exit 1
    ;;
esac

# https://github.com/mikefarah/yq/releases/download/v4.28.1/yq_darwin_amd64

_bin_name="yq_${_os}_${_arch}"

if [[ $DL_COMPRESSED == 'true' ]]; then
  _dl_name="${_bin_name}.tar.gz"
else
  _dl_name="${_bin_name}"
fi

_dl_path="$RUNNER_TEMP/${_dl_name}"
_dl_url="${_base_url}/$YQ_VERSION/${_dl_name}"

wget -O- "${_dl_url}" > "${_dl_path}"

if [[ $DL_COMPRESSED == 'true' ]]; then
  tar -xzvf "${_dl_path}"
  mv "$RUNNER_TEMP/${_bin_name}/${_bin_name}" "$YQ_BIN_DIR/yq"
  rm -rf "$RUNNER_TEMP/${_bin_name}"
  rm -rf "${_dl_path}"
else
  mv "$RUNNER_TEMP/${_bin_name}" "$YQ_BIN_DIR/yq"
  rm -rf "$RUNNER_TEMP/${_bin_name}"
fi

echo '::endgroup::'