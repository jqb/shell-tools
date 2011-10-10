#!/bin/bash


# CPP #########################################################################
function cpp-print-simple-build-file(){
    projectName=$1
    echo -e "#!/bin/bash"
    echo -e ""
    echo -e "g++ $projectName.cpp -o start.x && \\"
    echo -e "./start.x"
    echo -e ""
}

function cpp-etags(){
    dir=.
    if [ ! -z "$1" ]; then
	dir=$1
    fi
    etags --language c++ `find $dir -name '*.cpp' -or -name '*.hpp' -or -name '*.h'`
}

function cpp-create-simple-project(){
    echo -e "=================================="
    echo -e "This function does not exists"
    echo -e "_____________________________"
    echo -e "templates are missing"
    echo -e "=================================="
    return 1

    # previous code:
    projectName=$1
    buildFile=build
    mkdir $projectName && cd $projectName && touch $projectName.cpp $buildFile

    cpp-print-simple-build-file $projectName > $buildFile
    cat $TOOLS/templates/cpp-main-template > $projectName.cpp
    chmod +x $buildFile
    rtmp
    emacs $projectName.cpp
}

function cpp-create-project(){
    echo -e "=================================="
    echo -e "This function does not exists"
    echo -e "_____________________________"
    echo -e "templates are missing"
    echo -e "=================================="
    return 1

    # previous code:
    projectName=$1
    mkdir -p $projectName/src $projectName/test && cd $projectName

    cat $TOOLS/templates/makefile-cpp-template        > Makefile
    cat $TOOLS/templates/cpp-unit-test-suite-template > test/TestSuite.cpp
    cat $TOOLS/templates/cpp-main-template            > src/Main.cpp
    rtmp
    emacs src/Main.cpp
}
# END OF CPP #################################################################
