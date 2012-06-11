#!/bin/bash

. $TOOLS/programing-tools/programing-tools.sh
. $TOOLS/programing-tools/django_bash_completion

# . $TOOLS/programing-tools/java-tools.sh
# . $TOOLS/programing-tools/cpp-tools.sh
# . $TOOLS/programing-tools/python-tools.sh
# . $TOOLS/programing-tools/rails.bash
# . $TOOLS/programing-tools/grails_bash_completion


# bash completion for pip
eval "`pip completion --bash`"
