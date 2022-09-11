#!/usr/bin/env bash

# Global /etc/bashrc {{{
if [ -f "/etc/bashrc" ]; then
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
if [ -f "${HOME}/.bashrc_local" ]; then
  source "${HOME}/.bashrc_local"
fi

if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  PATH="${PATH}:${HOME}/.local/bin"
  export PATH
fi

if [[ ":${LD_LIBRARY_PATH}:" != *":${HOME}/.local/lib:"* ]]; then
  LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/.local/lib"
  export LD_LIBRARY_PATH
fi
# }}}

# Cargo {{{
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi
# }}}

# Node {{{
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  source "$NVM_DIR/nvm.sh"
  # Bash completion
  source "$NVM_DIR/bash_completion"
fi
# }}}

# pyenv {{{
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
# }}}

# GPG Tools {{{
# Necessary for TTY-based PIN entry
export GPG_TTY=$(tty)

gpg-encrypt () {
  default=0x12813A70E33FDA8A
  output=$(pwd)/"${1}".$(date +%s).enc
  gpg --encrypt --armor --output ${output} --recipient ${default} "${1}" \
    && echo "${1} => ${output}"
}

gpg-decrypt () {
  output=$(echo "${1}" | rev | cut -c16- | rev)
  gpg --decrypt --output ${output} "${1}" \
    && echo "${1} => ${output}"
}

gpg-sign () {
  output=$(pwd)/"${1}".$(date +%s).sig
  gpg --detach-sig --armor --output ${output} "${1}" \
    && echo "${1} => ${output}"
}
# }}}
