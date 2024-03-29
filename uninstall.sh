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
  echo "uninstall: Removing git remote (upstream) from dotfiles repository ..."
  pushd "${DOTFILES_ROOT}" &> /dev/null;
  if (git remote | grep -q upstream) then
      git remote remove upstream
    fi
  popd &> /dev/null;
fi

echo "uninstall: Cleaning ${PREFIX}/.vim/bundle plugins ..."
if [ -d "${DOTFILES_ROOT}/vim/common.vim/bundle" ]; then
  rm -rf "${DOTFILES_ROOT}/vim/common.vim/bundle"
fi

symremove () {
  local _source="${1}"
  local _prefix="${2}"
  local _target="${3}"

  echo "uninstall: Removing link ${_prefix}/${_target}"
  if [ -L "${_prefix}/${_target}" ]; then
    rm "${_prefix}/${_target}"
  fi

  # Restore any ".old" dotfiles
  if [ -f "${_prefix}/${_target}.old" ]; then
    echo "uninstall: Restoring backup of existing dotfile ${_prefix}/${_target}"
    mv "${_prefix}/${_target}.old" "${_prefix}/${_target}"
  fi
}

dotremove () {
  local _source="${1}"
  local _prefix="${2}"
  local _target=".${_source#*.}"

  symremove "${_source}" "${_prefix}" "${_target}"
}

dotremove bash/common.bash_profile "${PREFIX}"
dotremove bash/common.bashrc       "${PREFIX}"
dotremove zsh/common.zshrc         "${PREFIX}"
dotremove git/common.gitconfig     "${PREFIX}"
dotremove git/common.muttrc        "${PREFIX}"
dotremove other/common.inputrc     "${PREFIX}"
dotremove tmux/common.tmux.conf    "${PREFIX}"
dotremove termux                   "${PREFIX}"
dotremove vim/common.vimrc         "${PREFIX}"
dotremove vim/common.vim           "${PREFIX}"

symremove gpg/gpg.conf "${PREFIX}/.gnupg" "gpg.conf"

echo "uninstall: Complete"
