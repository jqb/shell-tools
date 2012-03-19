#!/usr/bin/python
# -*- coding: utf-8 -*-
__VERSION__ = "0.1"

import sys
import urllib2
from optparse import OptionParser

LIBS_URLS = {
    "JQUERY": "http://code.jquery.com/jquery{version}{min}.js",
    "LESS": "https://raw.github.com/cloudhead/less.js/master/dist/less{version}{min}.js",
}

def parse_options():
    description = "Simple javascript libs downloader (works only for: {names})"
    parser = OptionParser(description=description.format(names=unicode(LIBS_URLS.keys())))
    parser.add_option("-v", "--version", action="store_true",
                      dest="version", default=False,
                      help="Prints version of downloader")
    parser.add_option("-L", "--lib", dest="lib_name", default="",
                      help="Specify library name")
    parser.add_option("-V", "--lib-version", dest="lib_version", default="",
                      help="Specify version of library")
    parser.add_option("-m", "--min", action="store_true", dest="min",
                      default=False,
                      help="Download minified version")
    parser.add_option("-s", "--show-url", action="store_true", dest="show_url",
                      default=False,
                      help="Show costructed url only")
    options, args = parser.parse_args()
    return options

def format_version(version):
    """
    >>> format_version("1.3.4")
    >>> "-1.3.4"
    >>>
    >>> format_version("")
    >>> ""
    >>>
    >>> format_version("-1.5.6")
    >>> "-1.5.6"
    """
    if not version:
        return version
    if version.startswith('-'):
        return version
    return ''.join(['-', version])

def format_min(min_):
    """
    >>> format_min(True)
    >>> ".min"
    >>>
    >>> format_min(False)
    >>> ""
    """
    if min_:
        return ".min"
    return ""

def download(opts):
    if opts.version:
        print "js downloader v{version}".format(version=__VERSION__)
        return

    if not opts.lib_name:
        msg = "-L option (library name) need to be specified, avaiable: {names}"
        print msg.format(names=unicode(LIBS_URLS.keys()))
        return

    lib = LIBS_URLS.get(opts.lib_name.upper())
    if not lib:
        print "No such lib url: {name}".format(name=lib)
        return

    url = lib.format(version=format_version(opts.lib_version), min=format_min(opts.min))

    if opts.show_url:
        print url
        return

    for line in urllib2.urlopen(url):
        print line,

if __name__ == '__main__':
    download(parse_options())
