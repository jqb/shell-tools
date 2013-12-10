# SVN ###############################################
function svn-add-all(){
    svn add `svn st | grep ? | awk '{ print $2 }'`
}
# END OF SVN ########################################


# CLOJURE ##########################################
function clojure() {
    java -cp $TOOLS/programing-tools/clojure-1.3.0.jar clojure.main $@
}
# END OF CLOJURE ###################################
