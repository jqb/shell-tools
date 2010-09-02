#!/bin/bash


function java-print-build-file(){
    project_name=$1
    main_class=$2
    echo -e "#!/bin/bash"
    echo -e ""
    echo -e ""
    echo -e "# BASE DIRS ###############################"
    echo -e "BUILD_DIR=bin"
    echo -e "BUILD_DIR_TESTS=bintests"
    echo -e "DIST_DIR=dist"
    echo -e "SRC_DIR=src"
    echo -e "TEST_DIR=test"
    echo -e "###########################################"
    echo -e ""
    echo -e ""
    echo -e "# MAIN CLASS ##############################"
    echo -e "MAIN_CLASS=$main_class"
    echo -e "DIST_NAME=$project_name"
    echo -e "###########################################"
    echo -e ""
    echo -e ""
    echo -e "# CLASS PATH ##############################"
    echo -e "export LIBS=~/Dokumenty/library"
    echo -e "export CLASSPATH=\$CLASSPATH"
    echo -e "CLASSPATH=\$LIBS/java/junit-4.5.jar:\$CLASSPATH"
    echo -e "CLASSPATH=\$LIBS/java/commons-logging-1.0.4.jar:\$CLASSPATH"
    echo    "CLASSPATH=\`find \$LIBS/java/spring-framework-3.0.0.M4/dist -name '*.jar' | tr '\n' ':'\`:\$CLASSPATH"
    echo -e "CLASSPATH=\$DIST_DIR/\$DIST_NAME.jar:\$CLASSPATH"
    echo -e "###########################################"
    echo -e ""
    echo -e ""
    echo -e "# FUNCTIONS #######################################"
    echo -e "function java-print-manifest-file(){"
    echo -e "    main_class=\$1"
    echo -e "    echo -e \"Manifest-Version: 1.0\""
    echo -e "    echo -e \"Created-By: QbaJ\""
    echo -e "    echo -e \"Main-Class: \$main_class\""
    echo -e "}"
    echo -e ""
    echo -e ""
    echo -e "function build(){"
    echo -e "    echo \"[build]\""
    echo -e "    java-print-manifest-file \$MAIN_CLASS > Manifest"
    echo -e "    mkdir -p \$BUILD_DIR \$DIST_DIR"
    echo -e "    javac \`find \$SRC_DIR -name '*.java'\` -d \$BUILD_DIR  && \\"
    echo -e "        jar cfm \$DIST_NAME.jar Manifest -C \$BUILD_DIR . && \\"
    echo -e "        mv \$DIST_NAME.jar \$DIST_DIR"
    echo -e "}"
    echo -e ""
    echo -e ""
    echo -e "function build-tests(){"
    echo -e "    mkdir -p \$BUILD_DIR_TESTS \$DIST_DIR"
    echo -e "    javac \`find \$TEST_DIR -name '*.java'\` -d \$BUILD_DIR_TESTS"
    echo -e "}"
    echo -e ""
    echo -e ""
    echo -e "function run(){"
    echo -e "    java \$MAIN_CLASS"
    echo -e "}"
    echo -e ""
    echo -e ""
    echo -e "function build-and-run(){"
    echo -e "     clean ; build ; build-and-run-tests ; clean ; run"
    echo -e "}"
    echo -e ""
    echo -e ""
    echo -e "function clean(){"
    echo -e "     rm -rf \$BUILD_DIR Manifest \$BUILD_DIR_TESTS" 
    echo -e "}"
    echo -e ""
    echo -e ""
    echo -e "function build-and-run-tests(){"
    echo -e "    if [[ -e \$TEST_DIR ]] && [[ \"\$(ls -A \$TEST_DIR)\" ]]; then"
    echo -e "        mkdir -p \$BUILD_DIR_TESTS \$DIST_DIR"
    echo -e "        CLASSPATH=\$BUILD_DIR_TESTS:\$CLASSPATH"
    echo -e "        javac \`find \$TEST_DIR -name '*.java'\` -d \$BUILD_DIR_TESTS"
    echo -e "        java org.junit.runner.JUnitCore \\"
    echo -e "            \$(find \$BUILD_DIR_TESTS -name '*.class' | \\"
    echo -e "            sed -e 's/bintests\///g' -e 's/\.class//g' -e 's/\//\./g')"
    echo -e "    fi"
    echo -e "}"
    echo -e ""
    echo -e ""
    echo -e "##################################################"
    echo -e "build-and-run"
    echo -e ""
}


function java-print-main-class-file(){
    package=$1
    echo -e "package $package;"
    echo -e ""
    echo -e "public class Main {"
    echo -e "  public static void main(String... argv){"
    echo -e "  }"
    echo -e "}"
}


function java-print-hibernate-cfg-file-template(){
    cat $TOOLS/programing-tools/hibernate.cfg.xml.template
}


function java-print-spring-beans-file-template(){
    cat $TOOLS/programing-tools/beans.xml.template
}


function java-create-simple-project(){
    projectName=$1
    buildFile=build.sh
    mkdir $projectName && cd $projectName && touch $projectName.java $buildFile
    echo -e "javac $projectName.java \njava $projectName" > $buildFile
    echo -e ""                                           >  $projectName.java
    echo -e "public class $projectName {"                >> $projectName.java
    echo -e "\tpublic static void main(String... argv){" >> $projectName.java
    echo -e "\t}"                                        >> $projectName.java
    echo -e "}"                                          >> $projectName.java
    chmod +x $buildFile
    rtmp
    emacs $projectName.java
}


function java-create-project(){
    projectName=$1
    buildFile=build.sh
    packagePrefixDir=`if [ ! -z "$2" ]; then echo "$2"; else echo "pl/janoszek"; fi`
    packagePrefix=pl.janoszek
    mainClass=$packagePrefix.$projectName.Main

    mkdir $projectName && cd $projectName
    mkdir -p src/$packagePrefixDir/$projectName bin dist test

    # Generating 'manifest' and 'build.sh' files
    java-print-build-file $projectName $mainClass> $buildFile

    mainClassFile=src/$packagePrefixDir/$projectName/Main.java
    java-print-main-class-file $packagePrefix.$projectName > $mainClassFile
    # end of Generation

    chmod +x $buildFile
    rtmp
    . $buildFile
    emacs $mainClassFile $buildFile
}


function java-create-class(){
    python $TOOLS/programing-tools/create_java_class.py $@
}


function java-etags(){
    dir=.
    if [ ! -z "$1" ]; then 
	dir=$1
    fi
    etags --language java `find $dir -name *.java`
}


function java-build-project(){
    if [ -e "build.sh" ]; then
	. build.sh && build
    else
	echo -e "[error] build.sh file doesn't exists!"
    fi
}


function java-build-and-run-project(){
    if [ -e "build.sh" ]; then
	. build.sh && build-and-run
    else
	echo -e "[error] build.sh file doesn't exists!"
    fi
}


function java-run-project(){
    if [ -e "build.sh" ]; then
	. build.sh && run
    else
	echo -e "[error] build.sh file doesn't exists!"
    fi
}


function java-clean-project(){
    if [ -e "build.sh" ]; then
	. build.sh && clean
    else
	echo -e "[error] build.sh file doesn't exists!"
    fi
}


function merge-jars(){
    dist_name=$1
    class_path=$2
    mkdir $dist_name 

    for jar_file in $(echo $class_path | tr ':' ' '); do
        cp $jar_file $dist_name

        cd $dist_name
        unzip -o -q $jar_file
        
        if [ -e META-INF ]; then
            rm -rf META-INF
        fi
        
        rm `find . -name '*.jar'`
        cd ..        
    done
    # rm -rf $dist_name
}


# GROOVY ######################################################################
function groovy-create-simple-project(){
    projectName=$1
    buildFile=build.sh
    mkdir $projectName && cd $projectName && touch $projectName.groovy $buildFile
    echo -e "groovyc $projectName.groovy \ngroovy $projectName" > $buildFile
    echo -e ""                                                  > $projectName.groovy
    chmod +x $buildFile
    rtmp
    emacs $projectName.groovy
}
# END OF GROOVY ###############################################################
