# -*- coding: utf-8 -*-
import penv

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
from database_plugin import DatabasePlugin
from django_settings import DjangoSettingPlugin
from dotenv_bash import LoadDotEnv


penv.registry.add(
    # venv variable should go first
    EnvVariablesPlugin,
    LoadDotEnv,

    # then virtualenv before we'll actually calculate which python
    # should we use
    VirtualenvPlugin,
    PythonExecutablePlugin,

    LocalSettingFile,
    DjangoDivioProjectPlugin,

    CustomScriptsPlugin,
    SSHTOScriptsPlugin,

    DatabasePlugin,
    DjangoSettingPlugin,
)
