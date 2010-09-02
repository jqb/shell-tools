#!/usr/bin/env python
import sys
import re
import os

PYTHON_FILE_TEMPLATE= \
"""#!/usr/bin/env python
import sys


def main(params):
     pass


if __name__ == "__main__":
     main(sys.argv[1:])

"""

def usage():
     pass


__PYTHON_FILE_NAME_PTR = re.compile(r'.*\.py')
def has_python_file_extention(file_name):
     return __PYTHON_FILE_NAME_PTR.match(file_name)


def create_file(sys_params,file_template):
     try:
          file_name = sys_params[0]
          if not has_python_file_extention(file_name):
               file_name = file_name + ".py"
     except IndexError:
          usage()
     else:
          file = open(file_name,"w")
          file.write(file_template)
          os.chmod(file_name,772)


def main(params):
     create_file(params,PYTHON_FILE_TEMPLATE)


if __name__ == "__main__":
     main(sys.argv[1:])

