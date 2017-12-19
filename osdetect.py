#!/usr/bin/python

# simple Windows OS detection

import platform

opsys = platform.system()
release = platform.release()

print "You're on " + opsys + " " + release