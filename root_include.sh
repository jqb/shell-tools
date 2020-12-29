# GENERAL ##############################
export TOOLS=$HOME/tools
export EMAIL=kuba.janoszek@gmail.com
export SYSTEM_NAME=$(python -c "import os; print('%s' % os.name)")
export PLATFORM_NAME=$(uname | tr '[:upper:]' '[:lower:]')
########################################


function __include_all(){
    INCLUDE_FILE=$2
    for dir in $(echo $1 | tr ':' ' '); do
	for include_file in $(find $dir -name $INCLUDE_FILE); do
	    source $include_file
	done
    done
}

__include_all $TOOLS "$PLATFORM_NAME-before-include.sh"  # (darwin)-before-include.sh
__include_all $TOOLS "$SYSTEM_NAME-before-include.sh"    # (posix|nt)-include.sh
__include_all $TOOLS "include.sh"
__include_all $TOOLS "$SYSTEM_NAME-include.sh"           # (posix|nt)-include.sh
__include_all $TOOLS "$PLATFORM_NAME-include.sh"         # (darwin)-include.sh


function reload-all () {
    source $HOME/tools/root_include.sh
}
