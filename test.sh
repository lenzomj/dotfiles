#!/usr/bin/env bash

set -eE
trap teardown ERR

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PREFIX="/tmp/test_dotfiles.XXX"

throw_error () {
  printf "%s: Failed at line %d.\n" "${FUNCNAME[1]}" "${BASH_LINENO[0]}"
  return 1
}

setup () {
  PREFIX="$(mktemp -d "${PREFIX}")"

  echo "Setting up ${PREFIX} ..."
  echo "Existing .bashrc"    > "${PREFIX}/.bashrc"
  echo "Existing .vimrc"     > "${PREFIX}/.vimrc"
  echo "Existing .gitconfig" > "${PREFIX}/.gitconfig"
}

teardown () {
  echo "Cleaning up ${PREFIX} ..."
  rm -rf "${PREFIX}"
}

test_install () {
  ${ROOT}/install.sh "${PREFIX}"

  echo "- Install: Verifying symlinks ..."
  ( \
    [ "${ROOT}/bash/common.bash_profile" -ef "${PREFIX}/.bash_profile" ] \
    && [ "${ROOT}/bash/common.bashrc" -ef "${PREFIX}/.bashrc" ] \
    && [ "${ROOT}/git/common.gitconfig" -ef "${PREFIX}/.gitconfig" ] \
    && [ "${ROOT}/other/common.inputrc" -ef "${PREFIX}/.inputrc" ] \
    && [ "${ROOT}/tmux/common.tmux.conf" -ef "${PREFIX}/.tmux.conf" ] \
    && [ "${ROOT}/vim/common.vimrc" -ef "${PREFIX}/.vimrc" ] \
    && [ "${ROOT}/vim/common.vim/autoload/plug.vim" -ef \
         "${PREFIX}/.vim/autoload/plug.vim" ] \
  ) || throw_error

  echo "- Install: Verifying backups ..."
  ( \
    [ -s "${PREFIX}/.bashrc.old" ] \
    && [ -s "${PREFIX}/.vimrc.old"  ] \
    && [ -s "${PREFIX}/.gitconfig.old" ] \
  ) || throw_error
}

test_uninstall () {
  ${ROOT}/uninstall.sh "${PREFIX}"

  echo "- Uninstall: Verifying symlinks ..."
  ( \
    [ ! -L "${PREFIX}/.bash_profile" ] \
    && [ ! -L "${PREFIX}/.bashrc" ] \
    && [ ! -L "${PREFIX}/.gitconfig" ] \
    && [ ! -L "${PREFIX}/.inputrc" ] \
    && [ ! -L "${PREFIX}/.tmux.conf" ] \
    && [ ! -L "${PREFIX}/.vimrc" ] \
    && [ ! -L "${PREFIX}/.vim" ] \
  ) || throw_error

  echo "- Uninstall: Verifying backups ..."
  ( \
    [ -s "${PREFIX}/.bashrc" ] \
    && [ -s "${PREFIX}/.vimrc"  ] \
    && [ -s "${PREFIX}/.gitconfig" ] \
  ) || throw_error
}

setup
test_install
test_uninstall
teardown
