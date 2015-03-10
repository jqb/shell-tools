# -*- coding: utf-8 -*-
import os
import penv
import mixins


UNGZIP_FILE_BASH = """
    if [[ "$DUMP_FILE" == *gz ]]
    then
        echo "  ...ungzipping $DUMP_FILE"
        gzip -d $DUMP_FILE
        echo "  ...done."
        DUMP_FILE=${DUMP_FILE/.gz/}
    fi
"""

RECREATE_MYSQL = """
function recreate-db() {
    DUMP_FILE=$1
    DB_NAME=%(DATABASE_NAME)s
    CHARSET=%(DATABASE_CHARSET)s

%(UNGZIP_FILE_BASH)s

    echo "Recreating db..."
    echo "DROP DATABASE IF EXISTS $DB_NAME;" | mysql -u root
    echo "CREATE DATABASE $DB_NAME CHARSET $CHARSET;" | mysql -u root
    cat $DUMP_FILE | mysql -u root $DB_NAME
    echo "...done."
    mysql -u root -e "SHOW CREATE DATABASE $DB_NAME"
    echo "  ...gzipping $DUMP_FILE"
    gzip $DUMP_FILE && echo "  ...done."
}
"""

RECREATE_POSTGRES = """
function recreate-db () {
    DUMP_FILE=$1
    DB_NAME=%(DATABASE_NAME)s
    CHARSET=%(DATABASE_CHARSET)s

%(UNGZIP_FILE_BASH)s

    echo "Recreating db..."
    psql -U postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"
    psql -U postgres -c "CREATE DATABASE $DB_NAME ENCODING '$CHARSET';"

    cat $DUMP_FILE | psql -U postgres $DB_NAME
    echo "...done."
    echo "  ...gzipping $DUMP_FILE"
    gzip $DUMP_FILE && echo "  ...done."
}
"""


class DatabasePlugin(mixins.ParseDotEnvMixin,
                     penv.Plugin):
    """
    DatabasePlugin provides few simple tools that makes
    life with project databases less misserable.

    Basicaly I need two thigs (dump file name will be provided dynamicaly):

    - DATABASE_TYPE ("postgres" and "mysql" are supported)
    - DATABASE_NAME
    - DATABASE_CHARSET (utf8 by default)

    Root pass if needed, should be provided externally.
    """
    engines = {
        'django.db.backends.postgresql_psycopg2': 'postgres',
        'django.db.backends.mysql': 'mysql',
    }

    def get_defaults(self):
        return {
            'UNGZIP_FILE_BASH': UNGZIP_FILE_BASH,
        }

    def read_dotenv(self, path):
        if not os.path.exists(path):
            return {}

        import dj_database_url
        environ = self.parse_dotenv(path)
        DATABASE_URL = environ.get('DATABASE_URL', None)
        DATABASE = dj_database_url.parse(DATABASE_URL) if DATABASE_URL else None
        if DATABASE:
            return {
                'DATABASE_TYPE': self.engines.get(DATABASE['ENGINE']),
                'DATABASE_NAME': DATABASE['NAME'],
                'DATABASE_CHARSET': 'utf8',
            }
        return {}

    def get_dotenv_data(self, root_new):
        config = {}
        config.update(self.read_dotenv(root_new('.env')))
        config.update(self.read_dotenv(root_new('.env.local')))
        return config

    def get_environ_data(self):
        environ = {}
        DATABASE_TYPE = os.environ.get('DATABASE_TYPE')
        DATABASE_NAME = os.environ.get('DATABASE_NAME')
        DATABASE_CHARSET = os.environ.get('DATABASE_CHARSET')
        if DATABASE_TYPE:
            environ['DATABASE_TYPE'] = DATABASE_TYPE
        if DATABASE_NAME:
            environ['DATABASE_NAME'] = DATABASE_NAME
        if DATABASE_CHARSET:
            environ['DATABASE_CHARSET'] = DATABASE_CHARSET
        return environ

    def get_script(self, database_configuration):
        db_type = database_configuration['DATABASE_TYPE']
        script_template = {
            'postgres': RECREATE_POSTGRES,
            'mysql': RECREATE_MYSQL,
        }[db_type]
        return script_template % database_configuration

    def on_activate(self, root_new, root_old):
        dot_env = root_new('.env')
        local_dot_env = root_new('.env.local')
        if not os.path.exists(dot_env) and not os.path.exists(local_dot_env):
            return [
                '# database_plugin.DatabasePlugin: no .env or .env.local file :( => no fun. Sorry.'
            ]

        data = self.get_defaults()
        data.update(self.get_dotenv_data(root_new))
        data.update(self.get_environ_data())

        if (True
            or 'DATABASE_TYPE' not in data
            or 'DATABASE_NAME' not in data):
            return [
                '# database_plugin.DatabasePlugin: requires DATABASE_{TYPE,NAME} to be setup. Sorry.'
            ]

        script = self.get_script(data)
        return [script]

    def on_deactivate(self, root_new, root_old):
        return [
            self.bash.unset_f('recreate-db'),
        ]
