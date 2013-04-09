#!/bin/bash

function autoenv_has_virtualenv() {
    VIRTUALENV_FILE="$PWD/.virtualenv"
    if [ -e $VIRTUALENV_FILE ]; then
    	VIRTUALENV_NAME=$(cat $VIRTUALENV_FILE)
    	if [ -d "$WORKON_HOME/$VIRTUALENV_NAME" ]; then
	    if [ -z $VIRTUAL_ENV ] || [ $VIRTUAL_ENV -a $(basename "$VIRTUAL_ENV") != $VIRTUALENV_NAME ]; then
		workon $VIRTUALENV_NAME
	    fi
	else
	    VIRTUALENV_REQUIREMENTS="$PWD/requirements.txt"
	    if [ -f $VIRTUALENV_REQUIREMENTS ]; then
		mkvirtualenv $VIRTUALENV_NAME -r $VIRTUALENV_REQUIREMENTS
	    else
		mkvirtualenv $VIRTUALENV_NAME
	    fi
	    site_packages="`virtualenvwrapper_get_site_packages_dir`"
	    ln -s `virtualenvwrapper_get_site_packages_dir` "$PWD/.site-packages"
        fi
    else
	if [ $VIRTUAL_ENV ]; then
	    deactivate
	fi
    fi
}

function autoenv_venv_cd () {
    builtin cd $@ && autoenv_has_virtualenv
}

function cd() {
    autoenv_venv_cd $@
}
