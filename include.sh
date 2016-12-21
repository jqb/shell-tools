export EDITOR="emacs -nw"

if [ "$ZSH_ON" = "true" ]; then
    return
fi

export PS1="\u@\h \W$ "
