#!/bin/bash


export EDITOR="emacs -nw"
export PS1="\u@\h \W$ "


function parse-git-branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/'
}

function set-git-sensitive-prompt {
    local        BLUE="\[\033[0;34m\]"
    # OPTIONAL - if you want to use any of these other colors:
    local          RED="\[\033[0;31m\]"
    local    LIGHT_RED="\[\033[1;31m\]"
    local       YELLOW="\[\033[0;33m\]"
    local LIGHT_YELLOW="\[\033[1;33m\]"
    local        GREEN="\[\033[0;32m\]"
    local  LIGHT_GREEN="\[\033[1;32m\]"
    local        WHITE="\[\033[1;37m\]"
    local   LIGHT_GRAY="\[\033[0;37m\]"
    # END OPTIONAL

    local     DEFAULT="\[\033[0m\]"
    PS1="\W$LIGHT_YELLOW\$(parse-git-branch) $DEFAULT\$ "
}

set-git-sensitive-prompt

