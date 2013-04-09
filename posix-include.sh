#!/bin/bash


# ENVIRONMENT #################################################
# export LIBS='/home/kuba/docs/library'

# java
# export JAVA_HOME=/usr/lib/jvm/java-6-sun
# export JVM=$JAVA_HOME/bin
# export JBOSS_HOME=~/docs/library/java/jboss-5.1.0.GA
# export PATH=$JVM:$PATH

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
# export PATH=$HOME/Programy/sublime/:$PATH

# node.js
# export PATH=$HOME/Programy/node/bin:$PATH

# google appengine
export PATH=$HOME/docs/libs/google_appengine:$PATH

# RVM
source $HOME/.rvm/scripts/rvm
###############################################################



# ALIASES #####################################################
alias xselb='xsel -b'
###############################################################



# FUNCTIONS ###################################################
function set-uj-ip(){
    sudo ifconfig eth0 hw ether 00:60:08:BB:1F:9F
}

function set-bydgoska-ip(){
    sudo ifconfig eth0 hw ether 00:1A:80:BB:5C:84
}
###############################################################