#!/usr/bin/env bash

usage() {
  cat 1>&2 <<EOF
play.sh
The playbook index

USAGE:
    play.sh [FLAGS] [OPTIONS]

FLAGS:
    -h, --help      Print this help information
    -d, --dry-run   Verify playbook with --check; don't change anything
    -l, --local     Use local playbook; don't download anything

OPTIONS:
    -p, --profile <profile>   Installation profile (see PROFILES)
    -b, --branch  <branch>    Alternate playbook branch (default: master)

PROFILES:
    thinclient
    webclient
EOF
}

# Constants
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DEFAULT_BRANCH=master
SOURCE=https://raw.githubusercontent.com/lenzomj/dotfiles

# Profiles
DEFAULT_PROFILE=WEBCLIENT
declare -A PROFILES=(
  [thinclient]="provison-certs.yml
                provision-chrome.yml
                provision-cleanup.yml
                profile-thinclient.yml"

  [webclient]="provision-certs.yml
               provision-chrome.yml
               provision-cleanup.yml
               profile-webclient.yml"

  [workstation]="provision-certs.yml
                 provision-security.yml
                 provision-chrome.yml
                 provision-docker.yml
                 provision-cleanup.yml
                 profile-workstation.yml"
)

main() {
  local _local=0
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
      --local|-l)
        _local=1
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

  declare -a _manifest=(${PROFILES[${_profile}]})
  for file in "${_manifest[@]}"; do
    if [[ ${_local} -eq 0 ]]; then
      try curl -sS "${SOURCE}/${_branch}/playbook/${file}" -o "${_tmpdir}/${file}"
    else
      try cp "${SCRIPT_DIR}/${file}" "${_tmpdir}/${file}"
    fi
  done

  describe_inventory ${_tmpdir}

  pushd "${_tmpdir}" &> /dev/null;
    if [[ ${_dryrun} -eq 0 ]]; then
      try ansible-playbook -i hosts "profile-${_profile}.yml"
    else
      try ansible-playbook -i hosts "profile-${_profile}.yml" --check --diff
    fi
  popd &> /dev/null;

  try rm -rf ${_tmpdir}
}

describe_inventory() {
  cat << EOF > "${1}/hosts"
localhost

[local]
localhost

[local:vars]
ansible_connection=local
ansible_python_interpreter="/usr/bin/env python3"
EOF
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
