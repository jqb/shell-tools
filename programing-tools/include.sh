# Common things for systems

. $TOOLS/programing-tools/programing-tools.sh
. $TOOLS/programing-tools/django_bash_completion
. $TOOLS/programing-tools/rails.bash

# . $TOOLS/programing-tools/java-tools.sh
# . $TOOLS/programing-tools/cpp-tools.sh
. $TOOLS/programing-tools/python-tools.sh
# . $TOOLS/programing-tools/grails_bash_completion


# git terminal branch coloring
function parse_git_branch () {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function set_git_sensitive_prompt() {
   RED="\[\033[0;31m\]"
   YELLOW="\[\033[0;33m\]"
   GREEN="\[\033[0;32m\]"
   NO_COLOUR="\[\033[0m\]"
   PS1="$GREEN$NO_COLOUR\w$YELLOW\$(parse_git_branch)$NO_COLOUR\$ "
}

set_git_sensitive_prompt


# hg sensitive prompt
# hg_branch() {
#     hg branch 2> /dev/null | \
#         awk '{ printf "\033[37;0m on \033[35;40m" $1 }'
#     hg bookmarks 2> /dev/null | \
#         awk '/\*/ { printf "\033[37;0m at \033[33;40m" $2 }'
# }

# function set_hg_sensitive_prompt() {
#     DEFAULT="[37;40m"
#     PINK="[35;40m"
#     GREEN="[32;40m"
#     ORANGE="[33;40m"
#     PS1='\w\$(hg_branch)\e${GREEN}\e${DEFAULT}$ '
# }


function cd () {
    builtin cd $@ && eval "$(autovirtualenv_command)"
}

function db () {
    if [ -n "$MYSQL_CONFIG_FILE" ]; then
        echo -e "\n"
        echo -e "    Running mysql client, config file: $MYSQL_CONFIG_FILE"
        echo -e "\n"
        mysql --defaults-file=$MYSQL_CONFIG_FILE $@
    else
        mysql $@
    fi
}
