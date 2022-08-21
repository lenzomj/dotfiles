#!/usr/bin/env bash

#https://raw.githubusercontent.com/lenzomj/dotfiles/tune-up/playbook/provision-certs.yml
DEFAULT_BRANCH=master
SOURCE=https://raw.githubusercontent.com/lenzomj/dotfiles

usage() {
  cat 1>&2 <<EOF
play.sh
The playbook index

USAGE:
    play.sh [FLAGS] [OPTIONS]

FLAGS:
    -h, --help      Print this help information
    -d, --dry-run   Don't change anything

OPTIONS:
    -p, --profile <profile>   Installation profile (see PROFILES)
    -b, --branch  <branch>    Alternate playbook branch (default: master)

PROFILES:
    thinclient
    webclient
EOF
}

#Profiles
DEFAULT_PROFILE=WEBCLIENT
declare -A PROFILES=(
  [thinclient]="provison-certs.yml provision-vmware.yml provison-thinclient.yml"
  [webclient]="provision-certs.yml provision-chrome.yml provision-webclient.yml"
)

main() {
  local _dryrun=0
  local _profile=${DEFAULT_PROFILE}
  local _branch=${DEFAULT_BRANCH}
  local _tmpdir
  local _manifest

  while [[ $# -gt 0 ]]; do
    case "${1}" in
      --help|-h)
        usage
        exit 0
        ;;
      --dry-run|-d)
        _dryrun=1
        shift
        ;;
      --profile|-p)
        _profile=$(echo "${2}" | tr '[:upper:]' '[:lower:]')
        shift 2
        [[ "${PROFILES[${_profile}]+exists}" ]] || \
          err "unknown profile '${_profile}'"
        ;;
      --branch|-b)
        _branch=${2}
        shift 2
        ;;
      *)
        err "unkown flag or option '${1}'"
    esac
  done

  require curl
  require ansible-playbook

  _tmpdir="$(try mktemp -d)"

  fetch ${_profile} ${_branch} ${_tmpdir}

  pushd "${_tmpdir}" &> /dev/null;

  if [[ ${_dryrun} -eq 0 ]]; then
    try ansible-playbook "provision-${_profile}.yml"
  else
    try ansible-playbook "provision-${_profile}.yml" --check
  fi
  popd &> /dev/null;

  try rm -rf ${_tmpdir}
}

fetch() {
  local _manifest

  declare -a _manifest=(${PROFILES[${1}]})

  pushd "${3}" &> /dev/null;
  for file in "${_manifest[@]}"; do
    try curl -sS "${SOURCE}/${2}/playbook/${file}" -o ${file}
  done
  popd &> /dev/null;
}

say() {
  printf 'play: %s\n' "$1"
}

err() {
  say "$1" >&2
  exit 1
}

find_cmd() {
  command -v "$1" > /dev/null 2>&1
}

require() {
  if ! find_cmd "$1"; then
    err "need '$1' (command not found)"
  fi
}

try() {
  if ! "$@"; then err "command failed: $*"; fi
}

main "$@" || exit 1
