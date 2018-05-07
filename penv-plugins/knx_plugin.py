# -*- coding: utf-8 -*-
"""Plugin(s) related to work on KNX/IntelligentHome/etc... at Trifork

"""
import os
import penv


def here(*path):
    absolute_here = os.path.abspath(os.path.dirname(__file__))
    return os.path.abspath(os.path.join(absolute_here, *path))


ON_ACTIVATE = here('knx_plugin_on_activate')
ON_DEACTIVATE = here('knx_plugin_on_deactivate')


class KNXPlugin(penv.Plugin):
    plugin_trigger = '.knx.plugin'

    def on_activate(self, root_new, root_old):
        plugin_activate = root_new('.penv', self.plugin_trigger)
        plugin_activate_exists = os.path.exists(plugin_activate)

        if not plugin_activate_exists:
            return [
                '# KNXPlugin: %s does not exist' % plugin_activate,
                '# KNXPlugin: trigger file name is "%s"' % self.plugin_trigger,
            ]

        if plugin_activate and os.path.exists(ON_ACTIVATE):
            with open(ON_ACTIVATE, 'r') as script:
                return [
                    '# KNXPlugin: %s exists! Loading...' % plugin_activate,
                    script.read(),
                    '# KNXPlugin: Loading done.',
                ]

    def on_deactivate(self, root_new, root_old):
        plugin_deactivate = root_new('.penv', self.plugin_trigger)
        plugin_deactivate_exists = os.path.exists(plugin_deactivate)

        if not plugin_deactivate_exists:
            return [
                '# KNXPlugin :: %s does not exist - no deactivation' % plugin_deactivate,
                '# KNXPlugin: trigger file name is "%s"' % self.plugin_trigger,
            ]

        if os.path.exists(ON_DEACTIVATE):
            with open(ON_DEACTIVATE, 'r') as script:
                return [
                    script.read(),
                ]
