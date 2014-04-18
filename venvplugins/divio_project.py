# -*- coding: utf-8 -*-
from os.path import (
    abspath,
    join as pjoin,
    dirname,
    isdir,
    exists,
)

import autovenv  # from "onfly" module


class DjangoDivioProjectPlugin(autovenv.Plugin):
    def function_body(self, manage_script, args_and_options):
        return "%s %s" % (manage_script, args_and_options)

    def shell_or_shell_plus(self, manage_script):
        shell_command = "%s shell $@" % manage_script
        shell_plus_command = "%s shell_plus $@" % manage_script
        return ('if [[ $(django-manage 2>&1 | grep shell_plus) ]]; '
                'then {shell_plus_command}; '
                'else {shell_command}; '
                'fi').format(**locals())

    def get_src_directory(self, root_func):
        py_src = root_func('py_src')
        if exists(py_src):
            return py_src

        src = root_func('src')
        if exists(src):
            return src

    def get_buildout_script(self, root_func):
        script = root_func('bin', 'django')
        if exists(script):
            return script

    def get_manage_script(self, root_func):
        # The only kind of project I know about are those which
        # has either "src" or "py_src" directory
        src_dir = self.get_src_directory(root_func)
        if not src_dir:
            return self.get_buildout_script(root_func)  # might be None

        # I assume it's either:
        locations = [
            ('python', root_func(src_dir, '_manage_local_.py')), # my custom script for adri
            ('', root_func('bin', 'django')),                    # buildout
            ('python', root_func(src_dir, 'local')),             # like in mindsteps
            ('python', root_func(src_dir, 'manage.py')),         # like in mindsteps as well
        ]

        for python, loc in locations:
            if exists(loc):
                return "%s %s" % (python, loc)

    def on_activate(self, root_new, root_old):
        script = self.get_manage_script(root_new)
        if script:
            func = self.bash.function
            return [
                func("django-manage", self.function_body(script, '$@')),
                func("django-runserver", self.function_body(script, 'runserver $@')),
                func("django-shell", self.shell_or_shell_plus(script)),
                func("django-migrate", self.function_body(script, 'migrate $@')),
                func("django-schemamigration", self.function_body(script, 'schemamigration $@')),
            ]

    def on_deactivate(self, root_new, root_old):
        script = self.get_manage_script(root_old)
        if script:
            unset_f = self.bash.unset_f
            return [
                unset_f('django-manage'),
                unset_f('django-runserver'),
                unset_f('django-shell'),
                unset_f('django-migrate'),
                unset_f('django-schemamigration'),
            ]


autovenv.register.add(
    DjangoDivioProjectPlugin,
)
