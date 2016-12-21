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


if hash penv 2>/dev/null; then
    eval "`penv --startup-script`";
else
    echo "'penv' is not installed";
fi


function kill-find () {
    ps aux | grep $1
}

function kill-all () {
    ps aux | grep $1 | awk '{ print $2 }' | xargs kill -9
}

function git-log-graph () {
    # git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar(%ai)%Creset" $@
    git log --graph --pretty="format:%C(yellow)%h  %an, %ar(%ai)%Creset %Cblue%d%Creset %s %C(white)" $@
}

function git-log-graph-no-color () {
    git log --graph --pretty="format:%h%d %s %an, %ar" $@
}

function git-log-my () {
    author="$(echo $1 || echo Kuba Janoszek)"
    shift 1
    git log --pretty="format:%h | %ai | %d %s" --author="$author" $@
}

function git-compare-branches () {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $1..$2
}


# OWN TOOLS #########################################
function -current-directory-name () {
    dirname $(realpath $1)
}
# END OF OWN TOOLS ##################################


if [ "$ZSH_ON" = "true" ]; then
    return
fi

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

set_git_sensitive_prompt
# END OF GIT ########################################


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


# GNU GETTEXT
# msggrep $(find frontend/templates/report_manager -name "*.html" | awk '{ print "-N "$1 }' | tr '\n' ' ') locale/de/LC_MESSAGES/django.po
# END
