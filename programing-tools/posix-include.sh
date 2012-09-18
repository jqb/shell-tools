# VIRTUALENV SETUP
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME


source $TOOLS/programing-tools/programing-tools.sh
source $TOOLS/programing-tools/django_bash_completion
source $TOOLS/programing-tools/git_bash_completion

# source $TOOLS/programing-tools/python-tools.sh
# source $TOOLS/programing-tools/rails.bash
# source $TOOLS/programing-tools/grails_bash_completion


# bash completion for boilerplate
eval "`boil --bash-completion`"


# bash completion for pip
eval "`pip completion --bash`"


# Mac terminal ls colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
