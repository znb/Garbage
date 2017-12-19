#!/usr/bin/python

import os
import sys

if not os.geteuid()==0:
    sys.exit("\nOnly root can run this script\n")
else:
	print "homina homina homina"
