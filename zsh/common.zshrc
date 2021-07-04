#!/usr/bin/env zsh

export PATH="$HOME/Library/Python/3.8/bin:$PATH"

alias ls='ls -G'

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi
