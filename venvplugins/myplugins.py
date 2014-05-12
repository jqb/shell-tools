# -*- coding: utf-8 -*-
import os
import sys
from os.path import (
    join as pjoin,
    isdir,
    exists,
)
import autovenv  # from "onfly" module


class VirtualenvPlugin(autovenv.Plugin):
    def on_activate(self, root_new, root_old):
        default_file = root_new('.venv', 'default')
        default_env = root_new('.venv', 'env')

        if exists(default_file):
            virtualenv_name = open(default_file, "r").read().replace("\n", "")
            virtualenv_path = root_new('.venv', virtualenv_name)

            if isdir(virtualenv_path):
                return [self.bash.source(pjoin(virtualenv_path, 'bin', 'activate'))]
            else:
                return ["workon %s" % virtualenv_name]
        else:
            if isdir(default_env):
                return [self.bash.source(pjoin(default_env, 'bin', 'activate'))]


    def on_deactivate(self, root_new, root_old):
        if os.environ.get("VIRTUAL_ENV"):
            return ["deactivate"]


class CustomScriptsPlugin(autovenv.Plugin):
    def on_activate(self, root_new, root_old):
        script = root_new('.venv', 'on_activate')
        if exists(script):
            return [self.bash.source(script)]

    def on_deactivate(self, root_new, root_old):
        script = root_old('.venv', 'on_deactivate')
        if exists(script):
            return [self.bash.source(script)]


class SSHTOScriptsPlugin(autovenv.Plugin):
    _settings = None

    def get_deployment_settings(self, root):
        if not self._settings:
            sys.path.insert(0, root)
            from deployment import settings
            self._settings = settings
            sys.path.pop(0)
        return self._settings

    def server_names(self, root):
        settings = self.get_deployment_settings(root)
        return settings.keys()

    def ssh_command(self, name, root, user=None, host=None):
        deployment = self.get_deployment_settings(root)
        settings = deployment.get(name)
        if not settings:
            return None
        user = user or settings['user']
        host = host or settings['hosts'][0]  # take first
        return "ssh %s@%s" % (user, host)

    def function_body(self, project_env, root, **kwargs):
        ssh_command = self.ssh_command(project_env, root, **kwargs)
        if ssh_command:
            return "echo %s; %s" % (ssh_command, ssh_command)
        return 'echo "Sorry, but couldn\'t find any \'%s\' in deployment.py:"' % project_env

    def on_activate(self, root_new, root_old):
        script = root_new('deployment.py')
        if exists(script):
            root = root_new()
            return [
                self.bash.function("sshto-%s" % name, self.function_body(name, root))
                for name in self.server_names(root)
            ]

    def on_deactivate(self, root_new, root_old):
        script = root_old('deployment.py')
        if exists(script):
            root = root_old()
            return [
                self.bash.unset_f("sshto-%s" % name)
                for name in self.server_names(root)
            ]


autovenv.register.add(
    VirtualenvPlugin,
    CustomScriptsPlugin,
    SSHTOScriptsPlugin,
)
