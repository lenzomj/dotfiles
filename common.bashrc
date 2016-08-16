
# Environment Modules {{{
module() {
   if [ -e /usr/bin/modulecmd ]; then
      eval `/usr/bin/modulecmd bash $*`;
   fi
}

if [ -e /usr/bin/modulecmd ]; then
   if [ -d "$HOME/.modules" ]; then
      echo " - Using modulefiles in .modules"
      export APPLOCAL=$HOME/app
      module use $HOME/.modules
   fi

   if [ -d "/app/linux/modules" ]; then
      echo " - Using modulefiles in /app/linux/modules"
      module use /app/linux/modules
   fi

   module unuse /usr/share/Modules/modulefiles
fi

# }}}

[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && PATH="${PATH}:$HOME/.local/bin"

export PATH
