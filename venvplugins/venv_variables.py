# -*- coding: utf-8 -*-
from os.path import (
    abspath,
    join as pjoin,
    dirname,
    isdir,
    exists,
)
import autovenv  # from "onfly" module


class EnvVariablesPlugin(autovenv.Plugin):
    def on_activate(self, root_new, root_old):
        venv_dir = root_new('.venv')
        if exists(venv_dir):
            return [
                self.bash.export("VENV_ROOT", venv_dir),
                self.bash.export("VENV_ROOT_PARENT", root_new()),
            ]

    def on_deactivate(self, root_new, root_old):
        venv_dir = root_old('.venv')
        if exists(venv_dir):
            return [
                self.bash.unset("VENV_ROOT"),
                self.bash.unset("VENV_ROOT_PARENT"),
            ]


autovenv.register.add(EnvVariablesPlugin)
