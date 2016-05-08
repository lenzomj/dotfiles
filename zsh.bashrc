# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Change shell to zsh
{
  if [ -n "$(which zsh)" ]; then
    export SHELL=$(which zsh)
    [ -z "$ZSH_VERSION" ] && exec /bin/zsh -l
  fi
}
