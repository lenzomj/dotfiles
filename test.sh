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
  echo "test: Creating ${PREFIX} ..."
  echo "test: Creating ${PREFIX}/.bashrc"    | tee "${PREFIX}/.bashrc"
  echo "test: Creating ${PREFIX}/.zshrc"     | tee "${PREFIX}/.zshrc"
  echo "test: Creating ${PREFIX}/.vimrc"     | tee "${PREFIX}/.vimrc"
  echo "test: Creating ${PREFIX}/.gitconfig" | tee "${PREFIX}/.gitconfig"
  echo "test: Creating symlink ${PREFIX}/.inputrc"
  ln -s "/dev/null" "${PREFIX}/.inputrc"
}

teardown () {
  local _status="$?"
  if [ "${_status}" -ne 0 ]; then
    printf "%s: Error %d at line %d.\n" \
      "${FUNCNAME[1]}" "${_status}" "${BASH_LINENO[0]}"
  fi
  echo "test: Removing ${PREFIX} ..."
  rm -rf "${PREFIX}"
}

test_install () {
  echo "test: Executing ${ROOT}/setup.sh ..."
  "${ROOT}/setup.sh" "${PREFIX}"

  echo "test: Verifying symlinks ..."

  # Bash
  {
    [ "${ROOT}/bash/common.bash_profile" -ef "${PREFIX}/.bash_profile" ] \
    && [ "${ROOT}/bash/common.bashrc" -ef "${PREFIX}/.bashrc" ] \
    && [ "${ROOT}/other/common.inputrc" -ef "${PREFIX}/.inputrc" ] \
    && [ -s "${PREFIX}/.bashrc.old" ];
  } || throw_error

  # Git
  if command -v git >/dev/null 2>&1; then
    {
      [ "${ROOT}/git/common.gitconfig" -ef "${PREFIX}/.gitconfig" ] \
      && [ -s "${PREFIX}/.gitconfig.old" ];
    } || throw_error
  fi

  # Tmux
  if command -v tmux >/dev/null 2>&1; then
    {
      [ "${ROOT}/tmux/common.tmux.conf" -ef "${PREFIX}/.tmux.conf" ];
    } || throw_error
  fi

  # Vim
  if command -v vim >/dev/null 2>&1; then
    {
      [ "${ROOT}/vim/common.vimrc" -ef "${PREFIX}/.vimrc" ] \
      && [ "${ROOT}/vim/common.vim" -ef "${PREFIX}/.vim" ] \
      && [ -f "${PREFIX}/.vim/autoload/plug.vim" ] \
      && [ -s "${PREFIX}/.vimrc.old" ];
    } || throw_error
  fi

  # Neovim
  if command -v nvim >/dev/null 2>&1; then
    {
      [ -d "${PREFIX}/.config/nvim" ] \
      && [ -f "${PREFIX}/.config/nvim/init.vim" ];
    } || throw_error
  fi

  # zsh
  if command -v zsh >/dev/null 2>&1; then
    {
      [ "${ROOT}/zsh/common.zshrc" -ef "${PREFIX}/.zshrc" ] \
      && [ -s "${PREFIX}/.zshrc.old" ];
    } || throw_error
  fi
}

test_uninstall () {
  echo "test: Executing ${ROOT}/setup.sh -u ..."
  "${ROOT}/setup.sh" -u "${PREFIX}"

  echo "test: Verifying symlinks ..."
  { [ ! -L "${PREFIX}/.bash_profile" ] \
    && [ ! -L "${PREFIX}/.bashrc" ] \
    && [ ! -L "${PREFIX}/.inputrc" ] \
    && [ ! -L "${PREFIX}/.gitconfig" ] \
    && [ ! -L "${PREFIX}/.tmux.conf" ] \
    && [ ! -L "${PREFIX}/.vimrc" ] \
    && [ ! -L "${PREFIX}/.vim" ] \
    && [ ! -L "${PREFIX}/.zshrc" ] \
    && [ ! -L "${PREFIX}/.muttrc" ] \
    && [ ! -L "${PREFIX}/.gnupg/gpg.conf" ];
  } || throw_error

  echo "test: Verifying backups ..."
  { [ -s "${PREFIX}/.bashrc" ] \
    && [ -s "${PREFIX}/.zshrc" ] \
    && [ -s "${PREFIX}/.vimrc"  ] \
    && [ -s "${PREFIX}/.gitconfig" ];
  } || throw_error
}

setup
test_install
test_uninstall
teardown
