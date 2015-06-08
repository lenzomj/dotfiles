export WORK=$HOME/workspace
export TERM=xterm-256color
export THEMES=$HOME/.dotfiles/themes/
export APPS=$HOME/apps

export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk.x86_64

export LD_LIBRARY_PATH=$HOME/usr/lib64:$LD_LIBRARY_PATH

export PATH=$JAVA_HOME/bin:$PATH
export PATH=$HOME/usr/bin:$PATH
export PATH=$APPS/gradle-2.2.1/bin:$PATH
export PATH=$APPS/netbeans-8.0.2/bin:$PATH
export PATH=$APPS/apache-maven-3.2.5/bin:$PATH

eval `dircolors $THEMES/gnome-terminal-dircolors-solarized/dircolors.256dark`

alias ls='ls --color=auto'
alias yum='yum -c $HOME/etc/yum.conf'
export PS1="\u@devbox:\W\$ "


