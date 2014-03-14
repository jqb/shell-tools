##### Homebrew Formula: python
export PATH=/Users/divio/tools/bin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export ARCHFLAGS="-arch x86_64"


##### PIP Configuration: virtualenv
# Quite silly: can print "pip completion --bash" because of that
# export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
source /usr/local/bin/virtualenvwrapper.sh


# Mac iTerm2 hints:
# 1) cmd + delete -> kill word
#    http://felipecsl.com/blog/2012/06/05/protip-delete-words-on-iterm2-mac-osx/
#    hex sequence: 0x1b 0x08
#
# 2) word forward / backward: cmd + shift + F, cmd + shift + B
#    http://superuser.com/questions/357355/how-can-i-get-controlleft-arrow-to-go-back-one-word-in-iterm2


# Mac requires this. Otherwise:
# >>>
# >>> import locale
# >>>
#
# Will raise an exception
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


# Mac terminal ls colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad


# Docker
export DOCKER_HOST=tcp://127.0.0.1:4243
