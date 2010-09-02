#!/bin/bash


function python-django-set-settings-module() { 
    # add the current directory and the parent directory to PYTHONPATH
    # sets DJANGO_SETTINGS_MODULE
    export PYTHONPATH=$PYTHONPATH:$PWD/..
    export PYTHONPATH=$PYTHONPATH:$PWD
    if [ -z "$1" ]; then 
        x=${PWD/\/[^\/]*\/}               
        export DJANGO_SETTINGS_MODULE=$x.settings
    else    
        export DJANGO_SETTINGS_MODULE=$1 
    fi

    echo "DJANGO_SETTINGS_MODULE set to $DJANGO_SETTINGS_MODULE"
}

function python-create-file(){
    fileName=$1
    if [ -z "$fileName" ]; then
	echo "You need to specified file name..."
	return 1
    fi
    echo -e "#!/usr/bin/env python"    >  $fileName.py
    echo -e "import sys"               >> $fileName.py
    echo -e "\n"                       >> $fileName.py
    echo -e "if __name__ == \"__main__\":"  >> $fileName.py
    echo -e "     pass\n"                   >> $fileName.py
    chmod +x $fileName.py
    emacs $fileName.py
}

function python-create-simple-project(){
    projectName=$1
    mkdir $projectName && cd $projectName
    create-python-file $projectName
}

function python-django-modelviz-graph(){
    file=model_graph.png
    python $TOOLS/programing-tools/modelviz.py $@ | dot -Tpng -o $file && eog $file
}

function pycrm(){
    rm $(find -name '*.pyc')
}
