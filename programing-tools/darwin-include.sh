#!/bin/bash

function open-new-emacs () {
    open -n -a Emacs.app &
}


# apperently "stat" works a bit different in mac the on ubuntu...
function -current-directory-name () {
    _script="$(stat -f $1)"
    _base="$(dirname $_script)"
    echo $_base
}
