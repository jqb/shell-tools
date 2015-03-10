# -*- coding: utf-8 -*-
import os
import penv
import mixins


class LoadDotEnv(mixins.ParseDotEnvMixin,
                 penv.Plugin):
    """
    Reads .env file and sets all the variables to the current
    shell session. Before makes copy of "env" in plugin data
    directory
    """
    def export_variables(self, dotenv_file_path):
        vars_ = self.parse_dotenv_raw(dotenv_file_path)
        return [
            self.bash.export(key, val) for key, val in vars_.items()
        ]

    def unset_variables(self, dotenv_file_path):
        vars_ = self.parse_dotenv_raw(dotenv_file_path)
        return [
            self.bash.unset(key)
            for key, val in vars_.items()
            if key != 'PATH'  # we don't want to shoot ourself in the foot...
        ]

    def on_activate(self, root_new, root_old):
        dotenv_file = root_new('.env')
        if os.path.exists(dotenv_file):
            return [
                '# LoadDotEnv: ".env" exists: %s' % dotenv_file,
            ] + self.export_variables(dotenv_file)
        return ['# LoadDotEnv: ".env" DOESN\'T exists: %s' % dotenv_file]

    def on_deactivate(self, root_new, root_old):
        dotenv_file = root_new('.env')
        if os.path.exists(dotenv_file):
            return [
                '# LoadDotEnv: existing .env found in: %s | uninstalling...' % dotenv_file,
            ] + self.unset_variables(dotenv_file)
        return ['# LoadDotEnv: ".env" DOESN\'T exists: %s | nothing to deactivate' % dotenv_file]
