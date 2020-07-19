#!/usr/bin/env bash

# Global /etc/bashrc {{{
if [ -f "/etc/bashrc" ]; then
  # shellcheck source=/dev/null
  source "/etc/bashrc"
fi
# }}}

# Bash Colors {{{
if [ -x "/usr/bin/dircolors" ]; then
  test -r "${HOME}/.dircolors" && eval "$(dircolors -b "${HOME}/.dircolors")"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi
# }}}

# System Path {{{
if [ -f "${HOME}/.workspace.conf" ]; then
  # shellcheck source=/dev/null
  source "${HOME}/.workspace.conf"
fi

if [ ":${PATH}:" != *":${HOME}/.local/bin:"* ]; then
  PATH="${PATH}:${HOME}/.local/bin"
  export PATH
fi

if [ ":${PATH}:" != *":${HOME}/bin:"* ]; then
  PATH="${PATH}:${HOME}/bin"
  export PATH
fi
# }}}
