# -*- coding: utf-8 -*-
import os
import penv


def here(*path):
    absolute_here = os.path.abspath(os.path.dirname(__file__))
    return os.path.abspath(os.path.join(absolute_here, *path))


ON_ACTIVATE = here('monitor_files_plugin_on_activate.sh')
ON_DEACTIVATE = here('monitor_files_plugin_on_deactivate.sh')


class MonitorFilesPlugin(penv.Plugin):
    '''
    Monitor files recursively to trigger whatever action you'd like

    '''
    def on_activate(self, root_new, root_old):
        if os.path.exists(ON_ACTIVATE):
            with open(ON_ACTIVATE, 'r') as script:
                return [
                    script.read(),
                ]

    def on_deactivate(self, root_new, root_old):
        if os.path.exists(ON_DEACTIVATE):
            with open(ON_DEACTIVATE, 'r') as script:
                return [
                    script.read(),
                ]
