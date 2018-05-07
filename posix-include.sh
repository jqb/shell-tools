#!/bin/bash

# ENVIRONMENT #################################################
# export LIBS='/home/kuba/docs/library'

# java
# export JAVA_HOME=/usr/lib/jvm/java-6-sun
# export JVM=$JAVA_HOME/bin
# export JBOSS_HOME=~/docs/library/java/jboss-5.1.0.GA
# export PATH=$JVM:$PATH
export TOMCAT_HOME=~/.tomcat/apache-tomcat-8.5.24/
export PATH=$TOMCAT_HOME/bin/:$PATH


# grails & groovy
# export GRAILS_HOME=~/.grails
# PATH=$GRAILS_HOME/bin:$PATH

# GO programing laguage
# export GOROOT=$HOME/.go/lang
# export GOOS=linux
# export GOARCH=386
# export GOBIN=$HOME/.go/bin
# export PATH=$GOBIN:$PATH
# export GOWORKSPACE=$HOME/docs/projects/go/workspace
# export GOPATH=$GOWORKSPACE  # main package repo
# export PATH=$GOPATH/bin:$PATH
# according to GOBIN read this:
# http://stackoverflow.com/questions/17667803/go-install-always-uses-goroot-bin-instead-of-gopath


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
# export PATH=$HOME/docs/libs/google_appengine:$PATH

# RVM
# source $HOME/.rvm/scripts/rvm

# DOCKER
# if hash boot2docker 2>/dev/null; then
#     eval "$(boot2docker shellinit 2>/dev/null)"
# fi
# ^^^ instead of:
# export DOCKER_HOST=tcp://192.168.59.103:2376
# export DOCKER_CERT_PATH=/Users/divio/.boot2docker/certs/boot2docker-vm
# export DOCKER_TLS_VERIFY=1


# VM SHARED directory
export VM_SHARED=/media/sf_xubuntu-vm
###############################################################


function make-syncable () {
    export THIS_DIR_NAME=$(basename $PWD)

    if [ ! -d "$PWD/.penv" ]; then
        penv-ify
    fi

    cat > $PWD/.penv/on_activate <<EOF
#!/bin/bash

# NOTE: Slash in the end is very important
export SYNC_SRC=/media/sf_xubuntu-vm/code_sync/$THIS_DIR_NAME/
EOF

    cat > $PWD/.penv/on_deactivate <<EOF
#!/bin/bash

unset SYNC_SRC
EOF

    cd $PWD
    unset THIS_DIR_NAME
}


# ALIASES #####################################################
alias xselb='xsel -b'
###############################################################


function set-background-color() {
    echo "";
}
