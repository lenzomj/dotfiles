#!/usr/bin/env bash

# Source global definitions
if [[ -f /etc/bashrc ]]; then
  . /etc/bashrc
fi

# Bash Colors {{{
if [[ -x /usr/bin/dircolors ]]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || \
    eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
# }}}

# System Path {{{
if [[ -f "${HOME}/.workspace.conf" ]]; then
  source "${HOME}/.workspace.conf"
fi

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  PATH="${PATH}:$HOME/.local/bin"
  export PATH
fi
# }}}
