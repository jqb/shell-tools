# -*- coding: utf-8 -*-
import autovenv

from myplugins import (
    VirtualenvPlugin,
    CustomScriptsPlugin,
    SSHTOScriptsPlugin,
)
from venv_variables import (
    EnvVariablesPlugin,
)
from executable import (
    PythonExecutablePlugin,
)
from divio_project import (
    DjangoDivioProjectPlugin,
    LocalSettingFile,
)
# from database_plugin import DatabasePlugin


autovenv.register.add(
    # venv variable should go first
    EnvVariablesPlugin,

    # then virtualenv before we'll actually calculate which python
    # should we use
    VirtualenvPlugin,
    PythonExecutablePlugin,

    LocalSettingFile,
    DjangoDivioProjectPlugin,

    CustomScriptsPlugin,
    SSHTOScriptsPlugin,

    # DatabasePlugin,
)
