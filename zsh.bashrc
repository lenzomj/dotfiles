
{
  if [ -n "$(which zsh)" ]; then
    export SHELL=$(which zsh)
    [ -z "$ZSH_VERSION" ] && exec /bin/zsh -l
  fi
} 2> /dev/null

