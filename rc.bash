# /usr/local/bin takes precedence over /bin

##
# $DOTFILES Points to this directory
#
export DOTFILES="$HOME/.dotfiles"

for file in $DOTFILES/scripts/*.bash 
do
  if [[ -a $file ]] ; then source $file ; fi
done

# Export system paths
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/usr/local/bin:/usr/local/share/python:$PATH
export PATH=/usr/local/sbin:/usr/texbin:$PATH
export PATH=/usr/local/gnat/bin:$PATH
export PATH=/usr/local/Cellar/ruby/2.0.0-p247/bin:$PATH

launchctl setenv PATH $PATH 2> /dev/null

export JAVA_HOME=\
/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home

export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
export OpenCV_DIR=/usr/local/include/opencv

export PATH=$PYTHONPATH:$PATH

alias emacsclient=\
"/Applications/Emacs.app/Contents/MacOS/bin/emacsclient -nw"
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs -nw"
alias emacsdaemon_start="emacs --daemon"
alias emacsdaemon_stop="emacsclient -e '(kill-emacs)'"

alias mysql="/usr/local/mysql/bin/mysql"
alias mysqladmin="/usr/local/mysql/bin/mysqladmin"
export TERM="xterm-256color"
alias tmux="tmux -2"

alias org_export="emacs -eval '(org-batch-store-agenda-views)' -kill"

# Create editor alias
export EDITOR=vim
export ALTERNATE_EDITOR=emacs

# Update the terminal window title with user@hostname:dir
#export PROMPT_COMMAND=\
#'echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'

if [ "$PS1" ] ; then
  # Colorize directory listsings
  export CLICOLOR=1
  export LSCOLORS="gxfxcxdxbxegedabagacad"

  # Add colors to grep
  export GREP_OPTIONS='--color=auto'
  export GREP_COLOR='1;32'

  # MySQL prompt
  export MYSQL_PS1='\u@\h \d \c> '

  prompt="
    ldr='╭ '
    trl='╰ ➙ '

    usr='\[$E\]\u@\[$RST\]'
    hst='\[$E\]\h\[$RST\]'
    cwd='\[$W\]\w\[$RST\]'
    git=\"\$(__git_ps1 \"(\[$Y\]%s\[$RST\])\")\"

    trm=\"\${usr}\${hst}:\${cwd} \${git}\"
    trm=\"\[$Y\]\${ldr}\[$RST\] \${trm}\n\[$Y\]\${trl}\[$RST\]\"
    echo -e \"\${trm}\"
  "
  #export PS1="\$(${prompt})"

  #PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME} - ${PWD}\007"'
fi

# Tab complete in sudo
complete -cf sudo

# Ignore these commands from the history file
export HISTIGNORE="&:cd:ls:pwd:[bf]g:clear:exit"

# Append to the history instead of overwriting it.  Multiple terminals.
shopt -s histappend

# Add color to the terminal
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Special extract commands
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz)  tar xzf $1 ;;
            *.bz2)     bunzip2 $1 ;;
            *.rar)     rar x $1   ;;
            *.gz)      gunzip $1  ;;
            *.tar)     tar xf $1  ;;
            *.tbz2)    tar xjf $1 ;;
            *.tgz)     tar xzf $1 ;;
            *.zip)     unzip $1   ;;
            *)         echo "'$1' cannot be extracted via extract()"
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Pomodoro Hacks
function countdown
{
  local OLD_IFS="${IFS}"
  IFS=":"
  local ARR=( $1 )
  local SECONDS=$(((ARR[0] * 60 * 60) + (ARR[1] * 60) + ARR[2]))
  local START=$(date +%s)
  local END=$((START + SECONDS))
  local CUR=$START
    
  while [[ $CUR -lt $END ]]
  do
    CUR=$(date +%s)
    LEFT=$((END-CUR))
        
    printf "\r%02d:%02d:%02d" \
      $((LEFT/3600)) $(( (LEFT/60)%60)) $((LEFT%60))
        
    sleep 1
  done
  IFS="${OLD_IFS}"
  echo "        "
  growlnotify -s -m "Pomodoro Event!"
}

alias do_pomodoro="countdown '00:25:00'"
alias do_break="countdown '00:05:00'"
alias do_rest="countdown '00:30:00'"

