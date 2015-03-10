# -*- coding: utf-8 -*-
from os.path import exists

import penv


class PythonExecutablePlugin(penv.Plugin):
    def get_alternative_python_command(self, root_func):
        buildout_python = root_func('bin', 'python')
        if exists(buildout_python):
            return buildout_python

    def function_body(self, root_func):
        other_python = self.get_alternative_python_command(root_func)
        if not other_python:
            other_python = '$(which python)'
        cmd = (
            'if [ -n "$VIRTUAL_ENV" ]; '
            'then $VIRTUAL_ENV/bin/python "$@"; '
            'else {other_python} "$@"; '
            'fi'
        ).format(**locals())
        return cmd

    def echo_python(self, root_func):
        other_python = self.get_alternative_python_command(root_func)
        if not other_python:
            other_python = '$(which python)'
        cmd = (
            'if [ -n "$VIRTUAL_ENV" ]; '
            'then echo "$VIRTUAL_ENV/bin/python"; '
            'else echo "{other_python}"; '
            'fi'
        ).format(**locals())
        return cmd

    def on_activate(self, root_new, root_old):
        return [
            self.bash.function('python-executable', self.function_body(root_new)),
            self.bash.export('PYTHON_EXECUTABLE', '"$(%s)"' % self.echo_python(root_new)),
        ]

    def on_deactivate(self, root_new, root_old):
        return [
            self.bash.unset_f('python-executable'),
            self.bash.unset_f('PYTHON_EXECUTABLE'),
        ]
