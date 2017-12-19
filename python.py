#!/usr/bin/python
# EDITME

import argparse
import sys


def othermain():
    """HELP"""
    print "We are good to go."""


def __main__():
    """Get this party started"""
    parser = argparse.ArgumentParser(description='DESCRIPTION HERE')
    parser.add_argument('--configuration-file', '-c', dest='configfile', default='balls.cfg', help='Configuration File Yo')
    parser.add_argument('--all', '-a', dest='all', action="store_true", help='stuff')
    parser.add_argument('--version', '-v', action='version', version='%(prog)s 0.1')
    args = parser.parse_args()
    configfile = args.configfile
    ALL = args.all

    if not args.file:
        sys.exit(parser.print_help())
    else:
        othermain()


if __name__ == '__main__':
    __main__()
