# -*- coding: utf-8 -*-
from os.path import dirname

import penv
import mixins


class DjangoDivioProjectPlugin(penv.Plugin,
                               mixins.FabfileMixin,
                               mixins.ManageScriptMixin):

    def function_body(self, manage_script, args_and_options):
        return "%s %s" % (manage_script, args_and_options)

    def shell_or_shell_plus(self, manage_script):
        shell_command = "%s shell $@" % manage_script
        shell_plus_command = "%s shell_plus $@" % manage_script
        return ('if [ $(django-manage 2>&1 | grep shell_plus) ]; '
                'then {shell_plus_command}; '
                'else {shell_command}; '
                'fi').format(**locals())

    def run_fabric_script(self, root_func):
        location = self.get_fabfile_location(root_func)
        if not location:
            return self.bash.echo('Sorry, but couldn\'t find "fabfile.py"')

        script = [
            'CURRENT_DIR=$(pwd)',
            'builtin cd %s && fab "$@"' % dirname(location),
            'builtin cd $CURRENT_DIR',
        ]
        return ' && '.join(script)

    def python_script_command(self, root_func, script_body):
        # Make sure to run from src directory
        # bit akward but hey... it just works
        manage_location = self.get_manage_script_location(root_func)
        script = [
            'CURRENT_DIR=$(pwd)',
            'builtin cd %s' % manage_location,
            '$PYTHON_EXECUTABLE {script_body} "$@" '.format(**locals()),
            'builtin cd $CURRENT_DIR',
        ]
        return ' ; '.join(script)

    def show_project_info_body(self, root_func):
        script = (
            'echo "Python  : $($PYTHON_EXECUTABLE --version)"',
        )
        return '\n'.join(script)

    def on_activate(self, root_new, root_old):
        script = self.get_manage_script(root_new)
        if script:
            func = self.bash.function
            return [
                func("django-manage", self.function_body(script, '"$@"')),
                func("django-runserver", self.function_body(script, 'runserver "$@"')),
                func("django-shell", self.shell_or_shell_plus(script)),
                func("django-dbshell", self.function_body(script, 'dbshell "$@"')),
                func("django-migrate", self.function_body(script, 'migrate "$@"')),
                func("django-schemamigration", self.function_body(script, 'schemamigration "$@"')),
                func("django-schemamigration-auto", self.function_body(script, 'schemamigration --auto "$@"')),
                func("django-schemamigration-initial", self.function_body(script, 'schemamigration --initial "$@"')),
                func("django-datamigration", self.function_body(script, 'datamigration $@')),

                # additionals
                func("django-show-db-settings", self.python_script_command(
                    root_new, "-c 'from django.conf import settings; from pprint import pprint; pprint(settings.DATABASES)'")),
                func("django-show-migrationhistory", "echo 'select * from south_migrationhistory;' | django-dbshell | less"),
                func("django-show-db-tables", "echo 'show tables;' | django-dbshell | less"),
                func("venv-project-info", self.show_project_info_body(root_new)),
                func("run-fabric", self.run_fabric_script(root_new)),
            ]

    def on_deactivate(self, root_new, root_old):
        script = self.get_manage_script(root_old)
        if script:
            unset_f = self.bash.unset_f
            return [
                unset_f('django-manage'),
                unset_f('django-runserver'),
                unset_f('django-shell'),
                unset_f('django-dbshell'),
                unset_f('django-migrate'),
                unset_f('django-schemamigration'),
                unset_f('django-schemamigration-auto'),
                unset_f('django-schemamigration-initial'),
                unset_f('django-show-db-tables'),
                unset_f('django-show-db-settings'),
                unset_f('django-show-migrationhistory'),
                unset_f('django-datamigration'),
                unset_f('venv-project-info'),
                unset_f('run-fabric'),
            ]


class LocalSettingFile(penv.Plugin, mixins.LocalSettingFileMixin):
    def on_activate(self, root_new, root_old):
        result = self.get_local_settings_file(root_new)
        if result:
            local_settings_module, local_settings = result
            func = self.bash.function
            expo = self.bash.export
            return [
                expo('DJANGO_SETTINGS_MODULE', local_settings_module),
                func("django-show-settings-file", 'echo "Local settings file: %s"' % local_settings)
            ]

    def on_deactivate(self, root_new, root_old):
        result = self.get_local_settings_file(root_old)
        if result:
            local_settings_module, local_settings = result
            unset_f = self.bash.unset_f
            unset = self.bash.unset
            return [
                unset('DJANGO_SETTINGS_MODULE'),
                unset_f("django-show-settings-file"),
            ]
