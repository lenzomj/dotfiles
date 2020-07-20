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
  pushd "${DOTFILES_ROOT}" &> /dev/null;
  if (git remote | grep -q upstream) then
      git remote remove upstream
    fi
  popd &> /dev/null;
fi

#if [ "$(command -v vim)" ]; then
#  vim -E -s -u "${PREFIX}/.vimrc" +PlugClean +qall
#fi

symremove () {
  local _source="$1"
  local _target=".${_source#*.}"

  # Remove symlinks in ${PREFIX}
  if [ -L "${PREFIX}/${_target}" ]; then
    rm "${PREFIX}/${_target}"
  fi

  # Restore any ".old" dotfiles
  if [ -f "${PREFIX}/${_target}.old" ]; then
    mv "${PREFIX}/${_target}.old" "${PREFIX}/${_target}"
  fi
}

symremove bash/common.bash_profile
symremove bash/common.bashrc
symremove git/common.gitconfig
symremove other/common.inputrc
symremove tmux/common.tmux.conf
symremove vim/common.vimrc
symremove vim/common.vim
