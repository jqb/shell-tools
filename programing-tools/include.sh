#!/bin/bash

# . $TOOLS/programing-tools/java-tools.sh
# . $TOOLS/programing-tools/cpp-tools.sh

. $TOOLS/programing-tools/python-tools.sh
. $TOOLS/programing-tools/programing-tools.sh
. $TOOLS/programing-tools/django_bash_completion
# . $TOOLS/programing-tools/grails_bash_completion


export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME
