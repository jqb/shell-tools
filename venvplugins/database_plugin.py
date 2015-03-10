# -*- coding: utf-8 -*-
import os
import ast

import autovenv  # from "onfly" module


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


class DatabasePlugin(autovenv.Plugin):
    """
    DatabasePlugin provides few simple tools that makes
    live with project dbs less misserable.

    Basicaly I need two thigs (dump file name will be provided dynamicaly):

    - DATABASE_TYPE ("postgres" and "mysql" are supported)
    - DATABASE_NAME
    - DATABASE_CHARSET (utf8 by default)

    I don't need root pass as it's should be provided externally.
    """
    engines = {
        'django.db.backends.postgresql_psycopg2': 'postgres',
        'django.db.backends.mysql': 'mysql',
    }

    def get_defaults(self):
        return {
            'UNGZIP_FILE_BASH': UNGZIP_FILE_BASH,
        }

    def get_dotenv_data(self, root_new):
        import dj_database_url
        dot_env = root_new('.env')
        environ = {}
        with open(dot_env, 'r') as dot_env_file:
            for line in dot_env_file.readlines():
                line = line.strip()
                key, value = line.split("=", 1)
                environ[key] = ast.literal_eval(value)
        DATABASE_URL = environ.get('DATABASE_URL', None)
        DATABASE = dj_database_url.parse(DATABASE_URL) if DATABASE_URL else None
        if DATABASE:
            return {
                'DATABASE_TYPE': self.engines.get(DATABASE['ENGINE']),
                'DATABASE_NAME': DATABASE['NAME'],
                'DATABASE_CHARSET': 'utf8',
            }
        return {}

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
        data = self.get_defaults()
        data.update(self.get_dotenv_data(root_new))
        data.update(self.get_environ_data())
        script = self.get_script(data)
        return [
            script
        ]

    def on_deactivate(self, root_new, root_old):
        return [
            self.bash.unset_f('recreate-db'),
        ]
