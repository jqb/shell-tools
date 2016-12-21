# -*- coding: utf-8 -*-
import penv
import mixins


bash_function_body_p1 = """
function django-setting () {
    NAME=$1
    CURRENT_DIR=$(pwd)

    env | grep DJANGO_SETTINGS_MODULE;
"""

bash_function_body_p2 = """

    if [ -z "$NAME" ]; then
        $PYTHON_EXECUTABLE -c 'from django.conf import settings; from pprint import pprint; settings._setup(); pprint(settings._wrapped.__dict__)';
    else
        VARNAME=$NAME $PYTHON_EXECUTABLE <<EOF
from django.conf import settings
from pprint import pprint
from os import environ as e
from fnmatch import fnmatch
settings._setup()
keys = settings._wrapped.__dict__.keys()
keys = [key for key in keys if fnmatch(key, e.get("VARNAME"))]

result = {}
for key in keys:
    result[key] = getattr(settings, key)
pprint(result)
EOF
    fi

    cd $CURRENT_DIR;
}
"""


class DjangoSettingPlugin(mixins.ManageScriptMixin,
                          penv.Plugin):
    """
    Show's value of the given django setting

    1)
        $> django-setting
        ./path/to/settings file
        # displaying all the settings


    2)
        $> django-setting SETTING_NAME
        ./path/to/settings file
        # displays name and value of just one
    """

    def on_activate(self, root_new, root_old):
        script = self.get_manage_script(root_new)
        if script:
            src_directory = self.get_src_directory(root_new)
            return [
                "%s    cd %s%s" % (
                    bash_function_body_p1,
                    src_directory,
                    bash_function_body_p2)
            ]
        return [
            '# DjangoSettingPlugin :: no file "%s"' % script
        ]

    def on_deactivate(self, root_new, root_old):
        return [self.bash.unset_f('django-setting')]
