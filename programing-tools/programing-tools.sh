#!/bin/bash



# SVN ###############################################
function svn-add-all(){
    svn add `svn st | grep ? | awk '{ print $2 }'`
}
# END OF SVN ########################################



# BASH #############################################
function create-simple-bash-project(){
    projectName=$1
    mkdir $projectName && cd $projectName && touch $projectName.sh
    echo -e "#!/bin/bash\n" > $projectName.sh
    chmod +x $projectName.sh
    rtmp
    emacs $projectName.sh
}
# END OF BASH ######################################


# CLOJURE ##########################################
function clojure() {
    java -cp $TOOLS/programing-tools/clojure-1.3.0.jar clojure.main $@
}
# END OF CLOJURE ###################################