# -*- coding: utf-8 -*-
import os
import penv


def here(*path):
    absolute_here = os.path.abspath(os.path.dirname(__file__))
    return os.path.abspath(os.path.join(absolute_here, *path))


ON_ACTIVATE = here('grenzvergleich_plugin_on_activate')
ON_DEACTIVATE = here('grenzvergleich_plugin_on_deactivate')


class GrenzvergleichPlugin(penv.Plugin):
    plugin_trigger = '.gr.plugin'

    def on_activate(self, root_new, root_old):
        gr_plugin_activate = root_new('.penv', self.plugin_trigger)
        gr_plugin_activate_exists = os.path.exists(gr_plugin_activate)

        if not gr_plugin_activate_exists:
            return [
                '# GrenzvergleichPlugin: %s does not exist' % gr_plugin_activate,
                '# GrenzvergleichPlugin: trigger file name is "%s"' % self.plugin_trigger,
            ]

        if gr_plugin_activate and os.path.exists(ON_ACTIVATE):
            with open(ON_ACTIVATE, 'r') as script:
                return [
                    script.read(),
                ]

    def on_deactivate(self, root_new, root_old):
        gr_plugin_deactivate = root_new('.penv', '.gr.plugin')
        gr_plugin_deactivate_exists = os.path.exists(gr_plugin_deactivate)

        if not gr_plugin_deactivate_exists:
            return [
                '# GrenzvergleichPlugin :: %s does not exist - no deactivation' % gr_plugin_deactivate,
                '# GrenzvergleichPlugin: trigger file name is "%s"' % self.plugin_trigger,
            ]

        if os.path.exists(ON_DEACTIVATE):
            with open(ON_DEACTIVATE, 'r') as script:
                return [
                    script.read(),
                ]
