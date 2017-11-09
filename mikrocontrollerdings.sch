EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:switches
LIBS:relays
LIBS:motors
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:kingbright_leddisplay
LIBS:mikrocontrollerdings-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L LM7805_TO220 U1
U 1 1 5A00904C
P 2100 1050
F 0 "U1" H 1950 1175 50  0000 C CNN
F 1 "LM7805" H 2100 1175 50  0000 L CNN
F 2 "TO_SOT_Packages_THT:TO-220_Vertical" H 2100 1275 50  0001 C CIN
F 3 "" H 2100 1000 50  0001 C CNN
	1    2100 1050
	1    0    0    -1  
$EndComp
$Comp
L ATMEGA16A-PU U2
U 1 1 5A009083
P 7300 3500
F 0 "U2" H 6450 5380 50  0000 L BNN
F 1 "ATMEGA16A-PU" H 7750 1550 50  0000 L BNN
F 2 "DIL40" H 7300 3500 50  0001 C CIN
F 3 "" H 7300 3500 50  0001 C CNN
	1    7300 3500
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR1
U 1 1 5A0090E2
P 900 1000
F 0 "#PWR1" H 900 850 50  0001 C CNN
F 1 "VCC" H 900 1150 50  0000 C CNN
F 2 "" H 900 1000 50  0001 C CNN
F 3 "" H 900 1000 50  0001 C CNN
	1    900  1000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR2
U 1 1 5A0090FA
P 900 1500
F 0 "#PWR2" H 900 1250 50  0001 C CNN
F 1 "GND" H 900 1350 50  0000 C CNN
F 2 "" H 900 1500 50  0001 C CNN
F 3 "" H 900 1500 50  0001 C CNN
	1    900  1500
	1    0    0    -1  
$EndComp
$Comp
L AVR-ISP-6 CON1
U 1 1 5A009112
P 1800 3700
F 0 "CON1" H 1695 3940 50  0000 C CNN
F 1 "AVR-ISP-6" H 1535 3470 50  0000 L BNN
F 2 "AVR-ISP-6" V 1280 3740 50  0001 C CNN
F 3 "" H 1775 3700 50  0001 C CNN
	1    1800 3700
	1    0    0    -1  
$EndComp
$Comp
L Crystal Y1
U 1 1 5A009165
P 1800 2450
F 0 "Y1" H 1800 2600 50  0000 C CNN
F 1 "14.7456Mhz" H 1800 2300 50  0000 C CNN
F 2 "" H 1800 2450 50  0001 C CNN
F 3 "" H 1800 2450 50  0001 C CNN
	1    1800 2450
	0    1    1    0   
$EndComp
$Comp
L C C5
U 1 1 5A00969B
P 1400 2650
F 0 "C5" H 1425 2750 50  0000 L CNN
F 1 "22pF" H 1425 2550 50  0000 L CNN
F 2 "" H 1438 2500 50  0001 C CNN
F 3 "" H 1400 2650 50  0001 C CNN
	1    1400 2650
	0    -1   -1   0   
$EndComp
$Comp
L C C4
U 1 1 5A009700
P 1400 2250
F 0 "C4" H 1425 2350 50  0000 L CNN
F 1 "22pF" H 1425 2150 50  0000 L CNN
F 2 "" H 1438 2100 50  0001 C CNN
F 3 "" H 1400 2250 50  0001 C CNN
	1    1400 2250
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR3
U 1 1 5A009966
P 1150 2800
F 0 "#PWR3" H 1150 2550 50  0001 C CNN
F 1 "GND" H 1150 2650 50  0000 C CNN
F 2 "" H 1150 2800 50  0001 C CNN
F 3 "" H 1150 2800 50  0001 C CNN
	1    1150 2800
	1    0    0    -1  
$EndComp
Text GLabel 2950 1050 2    60   Input ~ 0
+5V
$Comp
L C C2
U 1 1 5A009C46
P 1550 1250
F 0 "C2" H 1575 1350 50  0000 L CNN
F 1 "0.33μF" H 1575 1150 50  0000 L CNN
F 2 "" H 1588 1100 50  0001 C CNN
F 3 "" H 1550 1250 50  0001 C CNN
	1    1550 1250
	1    0    0    -1  
$EndComp
$Comp
L C C3
U 1 1 5A009C97
P 2650 1250
F 0 "C3" H 2675 1350 50  0000 L CNN
F 1 "0.1μF" H 2675 1150 50  0000 L CNN
F 2 "" H 2688 1100 50  0001 C CNN
F 3 "" H 2650 1250 50  0001 C CNN
	1    2650 1250
	1    0    0    -1  
$EndComp
$Comp
L CP C1
U 1 1 5A00A139
P 1150 1250
F 0 "C1" H 1175 1350 50  0000 L CNN
F 1 "100µF" H 1175 1150 50  0000 L CNN
F 2 "" H 1188 1100 50  0001 C CNN
F 3 "" H 1150 1250 50  0001 C CNN
	1    1150 1250
	1    0    0    -1  
$EndComp
Text GLabel 7150 1300 1    60   Input ~ 0
+5V
Text GLabel 7450 1300 1    60   Input ~ 0
+5V
$Comp
L GND #PWR7
U 1 1 5A00A611
P 7250 5700
F 0 "#PWR7" H 7250 5450 50  0001 C CNN
F 1 "GND" H 7250 5550 50  0000 C CNN
F 2 "" H 7250 5700 50  0001 C CNN
F 3 "" H 7250 5700 50  0001 C CNN
	1    7250 5700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR8
U 1 1 5A00A637
P 7350 5700
F 0 "#PWR8" H 7350 5450 50  0001 C CNN
F 1 "GND" H 7350 5550 50  0000 C CNN
F 2 "" H 7350 5700 50  0001 C CNN
F 3 "" H 7350 5700 50  0001 C CNN
	1    7350 5700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR4
U 1 1 5A00A7C7
P 6100 3550
F 0 "#PWR4" H 6100 3300 50  0001 C CNN
F 1 "GND" H 6100 3400 50  0000 C CNN
F 2 "" H 6100 3550 50  0001 C CNN
F 3 "" H 6100 3550 50  0001 C CNN
	1    6100 3550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR5
U 1 1 5A00A90C
P 2250 3950
F 0 "#PWR5" H 2250 3700 50  0001 C CNN
F 1 "GND" H 2250 3800 50  0000 C CNN
F 2 "" H 2250 3950 50  0001 C CNN
F 3 "" H 2250 3950 50  0001 C CNN
	1    2250 3950
	1    0    0    -1  
$EndComp
Text GLabel 2550 3700 2    60   Input ~ 0
MOSI
Text GLabel 1000 3600 0    60   Input ~ 0
MISO
Text GLabel 1300 3700 0    60   Input ~ 0
SCK
Text GLabel 1000 3800 0    60   Input ~ 0
RST
Text GLabel 8500 3200 2    60   Input ~ 0
MOSI
Text GLabel 8850 3300 2    60   Input ~ 0
MISO
Text GLabel 8500 3400 2    60   Input ~ 0
SCK
Text GLabel 6100 1800 0    60   Input ~ 0
RST
$Comp
L TC07-11XWA DS1
U 1 1 5A00A2DD
P 2100 5900
F 0 "DS1" H 1750 6350 40  0000 C CNN
F 1 "TC07-11HWA" H 2300 6350 40  0000 C CNN
F 2 "TX07-11XWA" H 2100 6250 30  0000 C CIN
F 3 "" H 2100 5850 60  0000 C CNN
	1    2100 5900
	1    0    0    -1  
$EndComp
Text Notes 3100 700  0    60   ~ 0
Power
Text Notes 3200 3350 0    60   ~ 0
ISP
Text GLabel 1900 6550 3    60   Input ~ 0
C1
Text GLabel 2000 6800 3    60   Input ~ 0
C2
Text GLabel 2100 6550 3    60   Input ~ 0
C3
Text GLabel 2200 6800 3    60   Input ~ 0
C4
Text GLabel 2300 6550 3    60   Input ~ 0
C5
Text GLabel 1450 5600 0    60   Input ~ 0
R1
Text GLabel 1200 5700 0    60   Input ~ 0
R2
Text GLabel 1450 5800 0    60   Input ~ 0
R3
Text GLabel 1200 5900 0    60   Input ~ 0
R4
Text GLabel 1450 6000 0    60   Input ~ 0
R5
Text GLabel 1200 6100 0    60   Input ~ 0
R6
Text GLabel 1450 6200 0    60   Input ~ 0
R7
Connection ~ 2650 1050
Wire Wire Line
	2650 1050 2650 1100
Wire Wire Line
	2400 1050 2950 1050
Connection ~ 1150 2650
Wire Wire Line
	1250 2650 1150 2650
Wire Wire Line
	1150 2250 1150 2800
Wire Wire Line
	1250 2250 1150 2250
Connection ~ 1800 2650
Connection ~ 1800 2250
Wire Wire Line
	1550 2650 2200 2650
Wire Wire Line
	1800 2600 1800 2650
Wire Wire Line
	1800 2250 1800 2300
Wire Wire Line
	1550 2250 2200 2250
Wire Wire Line
	1550 1050 1550 1100
Wire Wire Line
	900  1050 1800 1050
Wire Wire Line
	1550 1450 1550 1400
Wire Wire Line
	900  1450 2650 1450
Wire Wire Line
	2100 1450 2100 1350
Wire Wire Line
	2650 1450 2650 1400
Connection ~ 2100 1450
Wire Wire Line
	1150 1050 1150 1100
Connection ~ 1550 1050
Wire Wire Line
	1150 1400 1150 1450
Connection ~ 1550 1450
Wire Wire Line
	900  1000 900  1050
Connection ~ 1150 1050
Wire Wire Line
	900  1500 900  1450
Connection ~ 1150 1450
Wire Wire Line
	7150 1300 7150 1500
Wire Wire Line
	7450 1300 7450 1500
Wire Wire Line
	7250 5500 7250 5700
Wire Wire Line
	7350 5500 7350 5700
Wire Wire Line
	1900 3800 2250 3800
Wire Wire Line
	2250 3800 2250 3950
Wire Wire Line
	1900 3700 2550 3700
Wire Wire Line
	1300 3700 1650 3700
Wire Wire Line
	8300 3200 8500 3200
Wire Wire Line
	8300 3300 8850 3300
Wire Wire Line
	8300 3400 8500 3400
Wire Wire Line
	6100 1800 6300 1800
Wire Notes Line
	550  550  3400 550 
Wire Notes Line
	3400 550  3400 1850
Wire Notes Line
	3400 1850 550  1850
Wire Notes Line
	550  1850 550  550 
Wire Wire Line
	1000 3600 1650 3600
Wire Wire Line
	1000 3800 1650 3800
Wire Notes Line
	550  3200 3400 3200
Wire Notes Line
	3400 3200 3400 4250
Wire Notes Line
	3400 4250 550  4250
Wire Notes Line
	550  4250 550  3200
Wire Wire Line
	1900 6450 1900 6550
Wire Wire Line
	2000 6450 2000 6800
Wire Wire Line
	2100 6450 2100 6550
Wire Wire Line
	2200 6450 2200 6800
Wire Wire Line
	2300 6450 2300 6550
Wire Wire Line
	1450 5600 1550 5600
Wire Wire Line
	1200 5700 1550 5700
Wire Wire Line
	1450 5800 1550 5800
Wire Wire Line
	1200 5900 1550 5900
Wire Wire Line
	1450 6000 1550 6000
Wire Wire Line
	1200 6100 1550 6100
Wire Wire Line
	1450 6200 1550 6200
Wire Notes Line
	550  5300 3400 5300
Wire Notes Line
	3400 5300 3400 7100
Wire Notes Line
	3400 7100 550  7100
Wire Notes Line
	550  7100 550  5300
Text Notes 3000 5450 0    60   ~ 0
Display
Text GLabel 8500 3600 2    60   Input ~ 0
C1
Text GLabel 8850 3700 2    60   Input ~ 0
C2
Text GLabel 8500 3800 2    60   Input ~ 0
C3
Text GLabel 8850 3900 2    60   Input ~ 0
C4
Wire Wire Line
	8300 3600 8500 3600
Wire Wire Line
	8300 3700 8850 3700
Wire Wire Line
	8300 3800 8500 3800
Wire Wire Line
	8300 3900 8850 3900
Text GLabel 8500 4000 2    60   Input ~ 0
C5
Wire Wire Line
	8300 4000 8500 4000
Text GLabel 8850 4100 2    60   Input ~ 0
R1
Text GLabel 8500 4200 2    60   Input ~ 0
R2
Text GLabel 8850 4300 2    60   Input ~ 0
R3
Text GLabel 8500 4500 2    60   Input ~ 0
R4
Text GLabel 8850 4600 2    60   Input ~ 0
R5
Text GLabel 8500 4700 2    60   Input ~ 0
R6
Text GLabel 8850 4800 2    60   Input ~ 0
R7
Wire Wire Line
	8300 4100 8850 4100
Wire Wire Line
	8300 4200 8500 4200
Wire Wire Line
	8300 4300 8850 4300
Wire Wire Line
	8300 4500 8500 4500
Wire Wire Line
	8300 4600 8850 4600
Wire Wire Line
	8500 4700 8300 4700
Wire Wire Line
	8300 4800 8850 4800
Text GLabel 2200 2250 2    60   Input ~ 0
XTAL2
Text GLabel 2200 2650 2    60   Input ~ 0
XTAL1
Text GLabel 6100 2200 0    60   Input ~ 0
XTAL2
Text GLabel 6100 2600 0    60   Input ~ 0
XTAL1
Wire Wire Line
	6100 2200 6300 2200
Wire Wire Line
	6100 2600 6300 2600
Wire Notes Line
	550  1900 3400 1900
Wire Notes Line
	3400 1900 3400 3150
Wire Notes Line
	3400 3150 550  3150
Wire Notes Line
	550  3150 550  1900
Text Notes 3100 2050 0    60   ~ 0
Clock
Text GLabel 2250 3600 2    60   Input ~ 0
+5V
Wire Wire Line
	1900 3600 2250 3600
$Comp
L SW_Push_SPDT SW1
U 1 1 5A00F5F4
P 1850 4700
F 0 "SW1" H 1850 4870 50  0000 C CNN
F 1 "SW_Push_SPDT" H 1850 4500 50  0000 C CNN
F 2 "" H 1850 4700 50  0001 C CNN
F 3 "" H 1850 4700 50  0001 C CNN
	1    1850 4700
	-1   0    0    -1  
$EndComp
Text GLabel 2200 4700 2    60   Input ~ 0
RST
$Comp
L GND #PWR6
U 1 1 5A00F861
P 1400 4900
F 0 "#PWR6" H 1400 4650 50  0001 C CNN
F 1 "GND" H 1400 4750 50  0000 C CNN
F 2 "" H 1400 4900 50  0001 C CNN
F 3 "" H 1400 4900 50  0001 C CNN
	1    1400 4900
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 5A00F88B
P 1400 4600
F 0 "R1" V 1480 4600 50  0000 C CNN
F 1 "10k" V 1400 4600 50  0000 C CNN
F 2 "" V 1330 4600 50  0001 C CNN
F 3 "" H 1400 4600 50  0001 C CNN
	1    1400 4600
	0    1    1    0   
$EndComp
Text GLabel 1100 4600 0    60   Input ~ 0
+5V
Wire Wire Line
	2050 4700 2200 4700
Wire Wire Line
	1550 4600 1650 4600
Wire Wire Line
	1400 4900 1400 4800
Wire Wire Line
	1400 4800 1650 4800
Wire Wire Line
	1100 4600 1250 4600
Wire Notes Line
	550  4300 3400 4300
Wire Notes Line
	3400 4300 3400 5250
Wire Notes Line
	3400 5250 550  5250
Wire Notes Line
	550  5250 550  4300
Text Notes 3300 4450 2    60   ~ 0
Reset button / pull-up
$Comp
L C C6
U 1 1 5A049669
P 6100 3250
F 0 "C6" H 6125 3350 50  0000 L CNN
F 1 "100nF" H 6125 3150 50  0000 L CNN
F 2 "" H 6138 3100 50  0001 C CNN
F 3 "" H 6100 3250 50  0001 C CNN
	1    6100 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	6300 3000 6100 3000
Wire Wire Line
	6100 3000 6100 3100
Wire Wire Line
	6100 3400 6100 3550
$EndSCHEMATC
