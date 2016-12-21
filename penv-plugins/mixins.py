# -*- coding: utf-8 -*-
import sys
import ast

from os.path import (
    exists,
    dirname,
)


class SrcDirectoryMixin(object):
    def get_src_directory(self, root_func):
        py_src = root_func('py_src')
        if exists(py_src):
            return py_src

        src = root_func('src')
        if exists(src):
            return src


class ManageScriptMixin(SrcDirectoryMixin):
    def get_buildout_script(self, root_func):
        script = root_func('bin', 'django')
        if exists(script):
            return script

    def get_manage_script_location(self, root_func):
        # The only kind of project I know about are those which
        # has either "src" or "py_src" directory
        src_dir = self.get_src_directory(root_func)
        if not src_dir:
            location = self.get_buildout_script(root_func)  # might be None
            if location:
                return dirname(location)
            return

        # I assume it's either:
        locations = [
            root_func(src_dir, '_manage_local_.py'), # my custom script for adri
            root_func('bin', 'django'),              # buildout
            root_func(src_dir, 'local'),             # like in mindsteps
            root_func(src_dir, 'manage.py'),         # like in mindsteps as well
        ]

        for loc in locations:
            if exists(loc):
                return dirname(loc)

    def get_manage_script(self, root_func):
        # The only kind of project I know about are those which
        # has either "src" or "py_src" directory
        src_dir = self.get_src_directory(root_func)

        # We don't have any "buildout" projects anymore:
        # if not src_dir:
        #     return self.get_buildout_script(root_func)  # might be None

        if not src_dir:
            locations = [
                ('$PYTHON_EXECUTABLE', root_func('manage.py')),                  # in current directory
            ]
            # loc = locations[0][1]
            # if not exists(loc):
            #     return "#  KURWA! python %s" % (loc)
        else:
            # I assume it's either:
            locations = [
                ('$PYTHON_EXECUTABLE', root_func(src_dir, '_manage_local_.py')), # my custom script for adri
                ('', root_func('bin', 'django')),                                # buildout
                ('$PYTHON_EXECUTABLE', root_func(src_dir, 'local')),             # like in mindsteps
                ('$PYTHON_EXECUTABLE', root_func(src_dir, 'manage.py')),         # like in mindsteps as well
            ]

        for python, loc in locations:
            if exists(loc):
                return "%s %s" % (python, loc)


class NonExistingDeploymentPY(object):
    def __init__(self):
        self.project_name = '"deployment.py" doesn\'t exists'
        self.settings = {}


class DeploymentScriptMixin(object):
    _deployment = None

    def get_deployment_py(self, root):
        if not self._deployment:
            sys.path.insert(0, root)
            try:
                import deployment
            except ImportError:
                self._deployment = NonExistingDeploymentPY()
            else:
                self._deployment = deployment
            sys.path.pop(0)
        return self._deployment

    def get_deployment_project_name(self, root):
        return self.get_deployment_py(root).project_name

    def get_deployment_settings(self, root):
        return self.get_deployment_py(root).settings

    def get_deployment_server_names(self, root):
        return self.get_deployment_py(root).settings.keys()


class LocalSettingFileMixin(DeploymentScriptMixin, ManageScriptMixin):
    def get_local_settings_file(self, root_func):
        # => (settings_module, settings_path)

        # newest kind of setup
        settings_local = root_func('src', 'settings_local.py-example')
        if exists(settings_local):
            return 'settings_local', root_func('src', 'settings_local.py')

        # older kind
        settings_local = root_func('py_src', 'project', 'personal.py-dist')
        if exists(settings_local):
            return 'project.personal', root_func('py_src', 'project', 'personal.py')

        settings_local = root_func('py_src', 'project', 'settings', 'personal.py-dist')
        if exists(settings_local):
            return 'project.settings.personal', root_func('py_src', 'project', 'settings', 'personal.py')

        root = root_func()
        project_name = self.get_deployment_project_name(root)

        settings_local = root_func('py_src', project_name, 'personal.py-dist')
        if exists(settings_local):
            return '%s.personal' % project_name, root_func('py_src', project_name, 'personal.py')

        settings_local = root_func('py_src', project_name, 'settings', 'personal.py-dist')
        if exists(settings_local):
            return '%s.settings.personal', root_func('py_src', project_name, 'settings', 'personal.py')

        # swisscom usermanagement location => completelly custom one
        settings_local = root_func('src', 'usermanagement', 'settings.py')
        if exists(settings_local):
            return 'usermanagement.settings', settings_local


class FabfileMixin(SrcDirectoryMixin):
    def get_fabfile_location(self, root_func):
        # In the root of project
        location = root_func('fabfile.py')
        if exists(location):
            return location

        # swisscom project
        location = root_func('env', 'fabfile.py')
        if exists(location):
            return location


class ParseDotEnvMixin(object):
    def parse_dotenv_raw(self, dotenv_file_path):
        environ = {}
        with open(dotenv_file_path, 'r') as dot_env_file:
            for line in dot_env_file.readlines():
                line = line.strip().rstrip()
                if line and not line.startswith('#'):
                    # yes... I've seen such in some .env:
                    # export MYVAR=.... <= let's strip "export"
                    if line.startswith('export '):
                        line = line.strip('export ')
                    key, value = line.split("=", 1)
                    environ[key] = value
        return environ

    def parse_dotenv(self, dotenv_file_path):
        environ = self.parse_dotenv_raw(dotenv_file_path)
        for key, val in environ.items():
            try:
                environ[key] = ast.literal_eval(val)
            except SyntaxError:
                pass
            except ValueError as e:
                if 'melformed string' in str(e):
                    environ[key] = val
        return environ
