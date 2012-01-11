#!/bin/bash


# DEFAULT EDITOR:
export EDITOR="emacs -nw"


# ALIASES #####################################################
alias xselb='xsel -b'
###############################################################
PS1="\u@\h \W$ "


function set-uj-ip(){
    sudo ifconfig eth0 hw ether 00:60:08:BB:1F:9F
}

function set-bydgoska-ip(){
    sudo ifconfig eth0 hw ether 00:1A:80:BB:5C:84
}
