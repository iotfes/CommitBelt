#!/usr/bin/env python

import time
import grovepi

# Connect the Grove Tilt Switch to digital port D7
# SIG,NC,VCC,GND
tilt_switch = 7

grovepi.pinMode(tilt_switch,"INPUT")

try:
	print(grovepi.digitalRead(tilt_switch))

except IOError:
	print ("Error")
