# HOME variable MUST be setup

function install_my_tools_scripts() {
    echo "Appending tools to bashrc..." && \
	echo "source \$HOME/tools/root_include.sh" >> $HOME/.bashrc
}

function install_git_config() {
    echo "Installing git config..." && \
	cp gitconfig.in $HOME/.gitconfig
}

function install_my_command_line_tools() {
    echo "Installing command line tools..." && \
	mkdir -p $HOME/bin && \
	for executable in $(ls ../bin); do ln -s $PWD/../bin/$executable $HOME/bin/$executable; done
}

