#!/bin/bash


export TOOLS=$HOME/Dokumenty/tools
PATH=$TOOLS/bin:$PATH

export EMAIL=kuba.janoszek@gmail.com
# ENVIRONMENT #################################################
# export LIBS='/home/kuba/Dokumenty/library'

# java
export JAVA_HOME=/usr/lib/jvm/java-6-sun
export JVM=$JAVA_HOME/bin
# export JBOSS_HOME=~/Dokumenty/library/java/jboss-5.1.0.GA
export PATH=$JVM:$PATH


# grails & groovy
# export GRAILS_HOME=~/.grails
# PATH=$GRAILS_HOME/bin:$PATH


# GO programing laguage
# export GOROOT=$HOME/.go/lang
# export GOOS=linux
# export GOARCH=386
# export GOBIN=$HOME/.go/bin
# PATH=$GOBIN:$PATH


# maven
# export MVN2_HOME='/usr/local/apache-maven/apache-maven-2.0.9'
# export MVN2=$MVN2_HOME/bin
# export MAVEN_OPTS='-Xms256m -Xmx512m'


# boost
# export BOOST_ROOT=/usr/local/boost_1_47_0

# cpp unit
# export CPP_UNIT_LIB=/usr/lib/libcppunit.a

# sublime text editor
export PATH=$HOME/Programy/sublime/:$PATH

# node.js
export PATH=$HOME/Programy/node/bin:$PATH

# ruby's RVM
[[ -s "~/.rvm/scripts/rvm" ]] && source "~/.rvm/scripts/rvm"
export PATH=$HOME/.rvm/bin:$PATH
###############################################################


function __include_all(){
    for dir in $(echo $1 | tr ':' ' '); do
	for include_file in $(find $dir -name 'include.sh'); do
	    # echo "Including subpackage: $include_file"
	    source $include_file
	done
    done
}


__include_all $TOOLS


function reload-all(){
    source $HOME/Dokumenty/tools/root_include.sh
}
