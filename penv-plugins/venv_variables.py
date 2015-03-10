# -*- coding: utf-8 -*-
from os.path import exists
import penv


class EnvVariablesPlugin(penv.Plugin):
    def on_activate(self, root_new, root_old):
        venv_dir = root_new(self.config.TRIGGER)
        if exists(venv_dir):
            return [
                self.bash.export("VENV_ROOT", venv_dir),
                self.bash.export("VENV_ROOT_PARENT", root_new()),
            ]

    def on_deactivate(self, root_new, root_old):
        venv_dir = root_old(self.config.TRIGGER)
        if exists(venv_dir):
            return [
                self.bash.unset("VENV_ROOT"),
                self.bash.unset("VENV_ROOT_PARENT"),
            ]
