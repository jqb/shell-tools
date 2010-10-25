touch ~/.sdirs

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

# bind completion command for g to _gcomp
complete -F _gcomp g
complete -F _gcomp p