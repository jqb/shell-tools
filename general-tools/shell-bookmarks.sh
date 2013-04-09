touch ~/.sdirs
touch ~/.esdirs

# enable custom tab completion
shopt -s progcomp


function s {
    cat ~/.sdirs | grep -v "export DIR_$1=" > ~/.sdirs1
    mv ~/.sdirs1 ~/.sdirs
    echo "export DIR_$1=$PWD" >> ~/.sdirs
}

function g {
    source ~/.sdirs
    cd $(eval $(echo echo $(echo \$DIR_$1)))
}

function p {
    source ~/.sdirs
    echo $(eval $(echo echo $(echo \$DIR_$1)))
}

function _l {
    source ~/.sdirs
    env | grep "^DIR_" | cut -c5- | grep "^.*=" | cut -f1 -d "="
}

# completion command for g
function _gcomp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_l`' -- $curw))
    return 0
}

function gworkon {
    source ~/.sdirs
    cd $(eval $(echo echo $(echo \$DIR_$1))) && workon $1
}


complete -F _gcomp g
complete -F _gcomp p
complete -F _gcomp gworkon


# DIRS FROM EMACS BOOKMARKS
function reload-emacs-bookmarks {
    convert-emacs-bmk > ~/.esdirs
}

function eg {
    reload-emacs-bookmarks && source ~/.esdirs
    cd $(eval $(echo echo $(echo \$DIR_$1)))
}

function ep {
    reload-emacs-bookmarks && source ~/.esdirs
    echo $(eval $(echo echo $(echo \$DIR_$1)))
}

function _el {
    reload-emacs-bookmarks && source ~/.esdirs
    env | grep "^DIR_" | cut -c5- | grep "^.*=" | cut -f1 -d "="
}

# completion command for eg
function _egcomp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_el`' -- $curw))
    return 0
}

complete -F _egcomp eg
complete -F _egcomp ep

