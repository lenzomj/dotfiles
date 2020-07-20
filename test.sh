#!/usr/bin/env bash

set -eE
trap teardown ERR

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PREFIX="/tmp/test_dotfiles.XXX"

throw_error () {
  return 1
}

setup () {
  PREFIX="$(mktemp -d "${PREFIX}")"
  echo "setup: Creating ${PREFIX} ..."
  echo "setup: Creating ${PREFIX}/.bashrc"    | tee "${PREFIX}/.bashrc"
  echo "setup: Creating ${PREFIX}/.vimrc"     | tee "${PREFIX}/.vimrc"
  echo "setup: Creating ${PREFIX}/.gitconfig" | tee "${PREFIX}/.gitconfig"
}

teardown () {
  local _status="$?"
  if [ "${_status}" -ne 0 ]; then
    printf "%s: Error %d at line %d.\n" \
      "${FUNCNAME[1]}" "${_status}" "${BASH_LINENO[0]}"
  fi
  echo "teardown: Removing ${PREFIX} ..."
  rm -rf "${PREFIX}"
}

test_install () {
  echo "test_install: Executing ${ROOT}/install.sh ..."
  source "${ROOT}/install.sh" "${PREFIX}"

  echo "test_install: Verifying symlinks ..."
  { [ "${ROOT}/bash/common.bash_profile" -ef "${PREFIX}/.bash_profile" ] \
    && [ "${ROOT}/bash/common.bashrc" -ef "${PREFIX}/.bashrc" ] \
    && [ "${ROOT}/git/common.gitconfig" -ef "${PREFIX}/.gitconfig" ] \
    && [ "${ROOT}/other/common.inputrc" -ef "${PREFIX}/.inputrc" ] \
    && [ "${ROOT}/tmux/common.tmux.conf" -ef "${PREFIX}/.tmux.conf" ] \
    && [ "${ROOT}/vim/common.vimrc" -ef "${PREFIX}/.vimrc" ] \
    && [ "${ROOT}/vim/common.vim/autoload/plug.vim" -ef \
         "${PREFIX}/.vim/autoload/plug.vim" ]; } || throw_error

  echo "test_install: Verifying backups ..."
  { [ -s "${PREFIX}/.bashrc.old" ] \
    && [ -s "${PREFIX}/.vimrc.old"  ] \
    && [ -s "${PREFIX}/.gitconfig.old" ]; } || throw_error
}

test_uninstall () {
  echo "test_install: Executing ${ROOT}/uninstall.sh ..."
  source "${ROOT}/uninstall.sh" "${PREFIX}"

  echo "test-uninstall: Verifying symlinks ..."
  { [ ! -L "${PREFIX}/.bash_profile" ] \
    && [ ! -L "${PREFIX}/.bashrc" ] \
    && [ ! -L "${PREFIX}/.gitconfig" ] \
    && [ ! -L "${PREFIX}/.inputrc" ] \
    && [ ! -L "${PREFIX}/.tmux.conf" ] \
    && [ ! -L "${PREFIX}/.vimrc" ] \
    && [ ! -L "${PREFIX}/.vim" ]; } || throw_error

  echo "test-uninstall: Verifying backups ..."
  { [ -s "${PREFIX}/.bashrc" ] \
    && [ -s "${PREFIX}/.vimrc"  ] \
    && [ -s "${PREFIX}/.gitconfig" ]; } || throw_error
}

setup
test_install
test_uninstall
teardown
