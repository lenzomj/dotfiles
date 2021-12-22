#!/usr/bin/env bash

set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PREFIX="$1"

if [ -z "${PREFIX}" ]; then
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
  else
    git remote set-url upstream "git@github.com:lenzomj/dotfiles.git"
  fi
  popd &> /dev/null;
fi

syminstall () {
  local _source="$1"
  local _prefix="$2"
  local _target=".${_source#*.}"

  echo "install: Creating link ${_prefix}/${_target}"
  if [ -L "${_prefix}/${_target}" ]; then
    ln -sfn "${DOTFILES_ROOT}/${_source}" "${_prefix}/${_target}"
  else
    if [ -f "${_prefix}/${_target}" ]; then
      echo "install: Creating backup of existing dotfile ${_prefix}/${_target}"
      mv "${_prefix}/${_target}" "${_prefix}/${_target}.old"
    fi
    ln -s "${DOTFILES_ROOT}/${_source}" "${_prefix}/${_target}"
  fi
}

syminstall bash/common.bash_profile "${PREFIX}"
syminstall bash/common.bashrc       "${PREFIX}"
syminstall git/common.gitconfig     "${PREFIX}"
syminstall other/common.inputrc     "${PREFIX}"
syminstall tmux/common.tmux.conf    "${PREFIX}"
syminstall termux                   "${PREFIX}"
syminstall vim/common.vimrc         "${PREFIX}"
syminstall vim/common.vim           "${PREFIX}"

echo "install: Creating file ${PREFIX}/.config/nvim/init.vim"
mkdir -p "${PREFIX}/.config/nvim"
cat << EOF > "${PREFIX}/.config/nvim/init.vim"
set runtimepath^=${PREFIX}/.vim runtimepath+=${PREFIX}/.vim/after
let &packpath = &runtimepath
source ${PREFIX}/.vimrc
EOF

#if [ "$(command -v vim)" ]; then
#  echo "install: Installing vim plugins ..."
#  vim -E -s -u "${PREFIX}/.vimrc" +PlugInstall +qall
#fi

echo "install: Complete"
