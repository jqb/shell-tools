# -*- coding: utf-8 -*-
import penv


# Change bash implementation
from penv.bash import Bash as BaseBash


class Bash(BaseBash):
    def unset(self, name):
        return 'unset %s >/dev/null 2>&1' % name

    def unset_f(self, name):
        return 'unset -f %s >/dev/null 2>&1' % name


penv.Plugin.bash = Bash()
# env / change bash implementation


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
from docker_plugin import DockerPlugin
from grenzvergleich_plugin import GrenzvergleichPlugin
from monitor_files_plugin import MonitorFilesPlugin
from knx_plugin import KNXPlugin


penv.registry.add(
    # venv variable should go first
    EnvVariablesPlugin,
    # LoadDotEnv,

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
    DockerPlugin,
    GrenzvergleichPlugin,
    MonitorFilesPlugin,
    KNXPlugin,
)
