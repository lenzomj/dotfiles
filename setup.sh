#!/usr/bin/env bash

set -e

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
UNINSTALL=0

show_help() {
  echo "Usage: setup [options] <prefix>"
  echo
  echo "Options:"
  echo "  -h        Show this help message"
  echo "  -u        Uninstall instead of install"
  echo
  echo "Arguments:"
  echo "  <prefix>  Required. Path to install/uninstall to/from."
}

# Creates symlinks to dotfiles in the prefix directory.
# Backs up any existing dotfiles with a ".old" suffix.
syminstall () {
  local _source="${1}"
  local _prefix="${2}"
  local _target="${3}"

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

# Removes symlinks to dotfiles in the prefix directory.
# Restores any existing dotfiles with a ".old" suffix.
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

# Convenience function to install dotfiles.
dotinstall () {
  local _source="${1}"
  local _prefix="${2}"
  local _target=".${_source#*.}"

  syminstall "${_source}" "${_prefix}" "${_target}"
}

# Convenience function to remove dotfiles.
dotremove () {
  local _source="${1}"
  local _prefix="${2}"
  local _target=".${_source#*.}"

  symremove "${_source}" "${_prefix}" "${_target}"
}

uninstall() {
  local prefix=$1
  echo "uninstall: Uninstalling from $prefix..."

  # Bash
  dotremove "bash/common.bash_profile" "${prefix}" # .bash_profile
  dotremove "bash/common.bashrc"       "${prefix}" # .bashrc
  dotremove "other/common.inputrc"     "${prefix}" # .inputrc

  # Git
  dotremove "git/common.gitconfig"     "${prefix}" # .gitconfig

  # Tmux
  dotremove "tmux/common.tmux.conf"    "${prefix}" # .tmux.conf

  # Vim
  dotremove "vim/common.vimrc"         "${prefix}" # .vimrc
  dotremove "vim/common.vim"           "${prefix}" # .vim

  # Neovim
  echo "uninstall: Removing file ${prefix}/.config/nvim/init.vim"
  rm -f "${prefix}/.config/nvim/init.vim"

  # zsh
  dotremove "zsh/common.zshrc"         "${prefix}" # .zshrc

  # Mutt
  dotremove "mutt/common.muttrc"       "${prefix}" # .muttrc

  # GPG
  symremove "gpg/gpg.conf" "${prefix}/.gnupg" "gpg.conf"

  echo "uninstall: Complete"
}

install() {
  local prefix=$1
  echo "install: Installing to $prefix..."

  # Bash
  dotinstall "bash/common.bash_profile" "${prefix}" # .bash_profile
  dotinstall "bash/common.bashrc"       "${prefix}" # .bashrc
  dotinstall "other/common.inputrc"     "${prefix}" # .inputrc

  # Git
  if command -v git >/dev/null 2>&1; then
    dotinstall "git/common.gitconfig"   "${prefix}" # .gitconfig
  fi

  # Tmux
  if command -v tmux >/dev/null 2>&1; then
    dotinstall "tmux/common.tmux.conf"  "${prefix}" # .tmux.conf
  fi

  # Vim
  if command -v vim >/dev/null 2>&1; then
    dotinstall "vim/common.vimrc"       "${prefix}" # .vimrc
    dotinstall "vim/common.vim"         "${prefix}" # .vim
  fi

  # Neovim
  if command -v nvim >/dev/null 2>&1; then
    echo "install: Creating file ${prefix}/.config/nvim/init.vim"
    mkdir -p "${prefix}/.config/nvim"
    {
      echo "set runtimepath^=${prefix}/.vim runtimepath+=${prefix}/.vim/after"
      echo "let &packpath = &runtimepath"
      echo "source ${prefix}/.vimrc"
    } > "${prefix}/.config/nvim/init.vim"
  fi

  # zsh
  if command -v zsh >/dev/null 2>&1; then
    dotinstall "zsh/common.zshrc"       "${prefix}" # .zshrc
  fi

  # Mutt
  if command -v mutt >/dev/null 2>&1; then
    dotinstall "mutt/common.muttrc"     "${prefix}" # .muttrc
  fi

  # GPG
  if command -v gpg >/dev/null 2>&1; then
    mkdir -p "${prefix}/.gnupg"
    chmod 700 "${prefix}/.gnupg"
    syminstall "gpg/gpg.conf" "${prefix}/.gnupg" "gpg.conf"
  fi

  echo "install: Complete"
}

# Parse options
while getopts ":hu" opt; do
  case $opt in
    h)
      show_help
      exit 0
      ;;
    u)
      UNINSTALL=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      show_help
      exit 1
      ;;
  esac
done

# Shift positional arguments
shift $((OPTIND -1))

# Ensure <prefix> is provided
if [ -z "$1" ]; then
  echo "Error: <prefix> argument is required." >&2
  show_help
  exit 1
fi

# Check if the prefix is a valid path
if [ ! -d "$1" ]; then
  echo "Error: '$1' is not a valid directory path." >&2
  exit 1
fi

# Run install or uninstall
if [ "$UNINSTALL" -eq 1 ]; then
  uninstall "$1"
else
  install "$1"
fi
