#!/bin/bash


# VIRTUALENV SETUP
export WORKON_HOME=$HOME/.virtualenvs
# source /usr/local/bin/virtualenvwrapper.sh
export PIP_VIRTUALENV_BASE=$WORKON_HOME


# bash completion for boilerplate
eval "`boil --bash-completion`"
