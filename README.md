# Amforth-utilities

Forth files written for use with Amforth on ATMega328P Arduino or similar

dot-2dr.frt  (.2dr)

	Prints a signed number n with two digits after the decimal point
	right justifed by r places e.g 25 5 .2dr | 0.25   -12 7 2d.r |  -0.12

dot-temp.frt  (.temp)

	Prints the temperature read by a DS18B20 sensor connected to Arduino pin 12
	to two decimal places. (Requires dot-2dr.frt)

dot-vcc.frt  (.vcc)

	Prints out the current Vcc of an ATMega by comparing it with the internal 1.1V reference.
	(Requires dot-2dr.frt)

