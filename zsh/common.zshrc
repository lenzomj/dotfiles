#!/usr/bin/env zsh

alias ls='ls -G'

# System Path {{{
if [ -f "${HOME}/.zshrc_local" ]; then
  source "${HOME}/.zshrc_local"
fi

if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
  PATH="${PATH}:${HOME}/.local/bin"
  export PATH
fi
# }}}

# Cargo {{{
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
# }}}

# Solana {{{
if [[ -d "$HOME/.local/share/solana/install/active_release/bin" ]]; then
  export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
fi
# }}}

# pyenv {{{
if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
# }}}
