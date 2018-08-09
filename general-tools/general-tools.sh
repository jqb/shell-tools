# FUNCTIONS ###################################################
function oldpwd(){
    cd $OLDPWD && ls
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
    dpath=$1
    if [ -z $dpath ]; then
	echo "You have to specified directory name."
	return
    fi
    name=`basename "$dpath"`
    tar -cf $name.tar $dpath/* && gzip $name.tar
}

function unpack(){
    dir=`echo $1 | awk -F"." '{ print $1 }'`
    mkdir $dir && cp $1 $dir && cd $dir
    tar -xf $1 && rm $1 && cd ..
}

function timer(){
    java -jar $TOOLS/general-tools/timer.jar $@
}
###############################################################
