#!/usr/bin/env python
import sys
import os

def usage():
     print "Create Java File, (C) Jakub Janoszek"
     print "Usage:"
     print "      create-java-class path/to/class/<class-name>[.java]"
     print ""


def build_class_file_content(packageName, class_name):
     return \
"""package %(packageName)s;
            
public class %(class_name)s {

}
""" % {
'packageName' : packageName,
"class_name" : class_name
}     


def main(params):
     file_path = params[1]

     tokens_to_leave = 0
     if file_path.startswith("/src/") or file_path.startswith("/test/"):
          tokens_to_leave = 2
     if file_path.startswith("src/") or file_path.startswith("test/"):
          tokens_to_leave = 1

     splited_file_path = file_path.split("/")

     class_name = splited_file_path[-1]
     if class_name.endswith(".java"):
          class_name = class_name.split(".")[0]

     dirs = "/".join(splited_file_path[:-1])
     package_name = ".".join(splited_file_path[tokens_to_leave:-1])

     try:
          os.makedirs(dirs)
     except OSError, e:
          pass # file exists, so that's fine

     if not file_path.endswith(".java"):
          file_path = file_path + ".java"
          
     file = open(file_path,"w")
     print >> file, build_class_file_content(package_name, class_name)
     

if __name__ == "__main__":
     try:
          main(sys.argv)
     except:
          print usage()

