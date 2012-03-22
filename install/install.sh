# This script all commonly used packages and scripts

. common.sh
# install_my_tools_scripts
# install_git_config
# install_my_command_line_tools


function install_git() {
    echo "Installing git..." && \
	sudo apt-get -y install git
}

function install_right_side_window_buttons() {
    echo "Installing window buttons on right side of windows..." && \
	gconftool-2 --set /apps/metacity/general/button_layout  --type string "menu:minimize,maximize,close"
}

function install_emacs() {
    echo "Installing emacs..." && \
	sudo apt-get -y install emacs23 && \
	git clone git@github.com:jqb/.emacs.d.git $HOME/.emacs.d && \
	git clone git@github.com:magit/magit.git $HOME/.emacs.d/magit
}

function install_tools() {
    echo "Installing tools..." && \
	sudo apt-get -y install ack-grep && \
	sudo ln -s /usr/bin/ack-grep /usr/bin/ack && \
	sudo apt-get -y install xsel
}

function install_python_tools() {
    echo "Installing python tools..." && \
	sudo apt-get -y install python-pip python-virtualenv virtualenvwrapper
}

function install_sun_java() {
    echo "Installing sun java..." && \
	sudo apt-add-repository ppa:flexiondotorg/java && \
	sudo apt-get update && \
	sudo apt-get -y install sun-java6-jre sun-java6-jdk sun-java6-plugin sun-java6-fonts
}


echo "Installer..." && \
    install_git && \
    install_git_config && \
    install_right_side_window_buttons && \
    install_emacs && \
    install_python_tools && \
    install_tools && \
    install_sun_java && \
    install_my_command_line_tools && \
    echo "...done"
