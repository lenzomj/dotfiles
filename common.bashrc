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

# Environment Modules {{{
MODULECMD=$(find ${HOME}/workspace/opt -name "modulecmd" -print -quit)
[[ -e "${MODULECMD}" ]] && HAS_MODULES=true;

module() {
   if [[ ${HAS_MODULES} ]]; then
      eval `$MODULECMD bash $*`;
   fi
}

if [[ ${HAS_MODULES} && (! -z "$PS1") ]]; then
  if [[ -d "${HOME}/workspace/modules/library" ]]; then
    echo " - Using modulefiles in ${HOME}/workspace/modules/library"
    module use ${HOME}/workspace/modules/library
  fi
fi

# }}}

# System Path {{{
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  PATH="${PATH}:$HOME/.local/bin"
fi

if [[ ":$PATH:" != *":$HOME/workspace/opt/bin:"* ]]; then
  PATH="${PATH}:$HOME/workspace/opt/bin"
fi

export PATH

# }}}
