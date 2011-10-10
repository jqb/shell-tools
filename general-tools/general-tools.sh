#!/bin/bash


# FUNCTIONS ###################################################
function oldpwd(){
    cs $OLDPWD
}

function rtmp(){
    if [ "$1" == "-r" ]; then
	rm `find . -name '*~'` 2> /dev/null
	rm `find . -name '.*~'` 2> /dev/null
	return 0
    fi
    rm *~ 2> /dev/null
    rm .*~ 2> /dev/null
}

function rmf(){
    for item in $@; do
	rm -rf $@
    done
}

function mk-month-dir(){
    mkdir `date +%Y-%B`
}

function pack-dir(){
    path=$1
    if [ -z $path ]; then
	echo "You have to specified directory name."
	return
    fi
    name=`basename "$path"`
    tar -cf $name.tar $path/* && gzip $name.tar
}

function unpack(){
    dir=`echo $1 | awk -F"." '{ print $1 }'`
    mkdir $dir && cp $1 $dir && cd $dir
    tar -xf $1 && rm $1 && cd ..
}

function timer(){
    java -jar $TOOLS/general-tools/timer.jar $@
}

function translate() {
    echo "[`wget -qO- --user-agent firefox \"https://www.googleapis.com/language/translate/v2?key=YOUR KEY&q=$3&source=$1&target=$2\"`]" \
	| jsawk -a "return this[0].data.translations[0].translatedText" \
	| perl -MHTML::Entities -pe 'decode_entities($_)'
}
###############################################################
