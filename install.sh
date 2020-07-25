#!/usr/bin/env bash

set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PREFIX="$1"

if [ -z "$PREFIX" ]; then
  printf '%s\n' \
    "usage: $0 <prefix>" \
    "  e.g. $0 \$HOME" >&2
  exit 1
fi

if [ -d "${DOTFILES_ROOT}/.git" ]; then
  echo "install: Adding git remote (upstream) to dotfiles repository ..."
  pushd "${DOTFILES_ROOT}" &> /dev/null;
  if ! (git remote | grep -q upstream) then
      git remote add upstream "git@github.com:lenzomj/dotfiles.git"
    fi
  popd &> /dev/null;
fi

syminstall () {
  local _source="$1"
  local _target=".${_source#*.}"

  echo "install: Creating link ${PREFIX}/${_target}"
  if [ -L "${PREFIX}/${_target}" ]; then
    ln -sfn "${DOTFILES_ROOT}/${_source}" "${PREFIX}/${_target}"
  else
    if [ -f "${PREFIX}/${_target}" ]; then
      echo "install: Creating backup of existing dotfile ${PREFIX}/${_target}"
      mv "${PREFIX}/${_target}" "${PREFIX}/${_target}.old"
    fi
    ln -s "${DOTFILES_ROOT}/${_source}" "${PREFIX}/${_target}"
  fi
}

syminstall bash/common.bash_profile
syminstall bash/common.bashrc
syminstall git/common.gitconfig
syminstall other/common.inputrc
syminstall tmux/common.tmux.conf
syminstall vim/common.vimrc
syminstall vim/common.vim

if [ "$(command -v vim)" ]; then
  echo "install: Installing vim plugins ..."
  vim -E -s -u "${PREFIX}/.vimrc" -V2 +PlugInstall +qall
fi

echo "install: Complete"
