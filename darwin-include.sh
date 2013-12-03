##### Homebrew Formula: python
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export ARCHFLAGS="-arch x86_64"


##### PIP Configuration: virtualenv
# Quite silly: can print "pip completion --bash" because of that
# export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
source /usr/local/bin/virtualenvwrapper.sh
