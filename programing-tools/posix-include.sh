# VARIABLES #######################################
export WORKON_HOME=$HOME/.virtualenvs
# source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME
# END OF VARIABLES ################################



# SVN ###############################################
function svn-add-all(){
    svn add `svn st | grep ? | awk '{ print $2 }'`
}
# END OF SVN ########################################



# CLOJURE ##########################################
function clojure() {
    java -cp $TOOLS/programing-tools/clojure-1.3.0.jar clojure.main $@
}
# END OF CLOJURE ###################################



# GIT TERMINAL BRANCH COLORING #####################
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

function git-log-graph () {
    git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset" $@
}

set_git_sensitive_prompt
# END OF GIT ########################################



# OWN TOOLS #########################################
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
# END OF OWN TOOLS ##################################



# ADDITIONAL IMPORTS
. $TOOLS/programing-tools/django_bash_completion
. $TOOLS/programing-tools/git_bash_completion
# . $TOOLS/programing-tools/rails.bash
# . $TOOLS/programing-tools/grails_bash_completion



# COMPLECTIONS
# bash completion for boilerplate
eval "`boil --bash-completion`"

# bash completion for pip
eval "`pip completion --bash`"
# END OF COMPLECTIONS
