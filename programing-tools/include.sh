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
   PS1="$GREEN\u@machine$NO_COLOUR:\w$YELLOW\$(parse_git_branch)$NO_COLOUR\$ "
}

set_git_sensitive_prompt

