# GENERAL ##############################
export TOOLS=$HOME/tools
export EMAIL=kuba.janoszek@gmail.com
export PLATFORM_NAME=$(python -c "import os; print '%s' % os.name")
export SYSTEM_NAME=$(uname | tr '[:upper:]' '[:lower:]')
########################################


function __include_all(){
    SYS=$PLATFORM_NAME
    SYSNAME=$SYSTEM_NAME
    for dir in $(echo $1 | tr ':' ' '); do
	for include_file in $(find $dir -name "$SYSNAME-include.sh" -or -name "include.sh" -or -name "$SYS-include.sh"); do
	    # echo "Including subpackage: $include_file"
	    source $include_file
	done
    done
}


__include_all $TOOLS


function reload-all(){
    source $HOME/tools/root_include.sh
}
