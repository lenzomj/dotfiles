
# /usr/local/bin takes precedence over /bin
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/Cellar/python/2.7.1/bin:$PATH
export PATH=/usr/local/Cellar/ruby/1.9.2-p180/bin/:$PATH

# Update the terminal window title with user@hostname:dir
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'

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