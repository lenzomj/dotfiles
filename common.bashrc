
# Environment Modules {{{
module() {
   if [ -e /usr/bin/modulecmd ]; then
      eval `/usr/bin/modulecmd bash $*`;
   fi
}

if [ -e /usr/bin/modulecmd ]; then
   
   export APPLOCAL=$HOME/app
   
   if [ -d "$HOME/.modules" ]; then
      echo " - Using modulefiles in .modules"
      module use $HOME/.modules
   fi

   if [ -d "$HOME/.modules_local" ]; then
      echo " - Using modulefiles in .modules_local"
      module use $HOME/.modules_local
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
