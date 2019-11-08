import RPi.GPIO as GPIO
import time
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(21,GPIO.OUT)
GPIO.setup(20,GPIO.OUT)
GPIO.setup(16,GPIO.OUT)
print "LED on"
GPIO.output(20,GPIO.HIGH)
GPIO.output(16,GPIO.HIGH)
GPIO.output(21,GPIO.HIGH)
time.sleep(5) 
print "LED off"
GPIO.output(20,GPIO.LOW)
GPIO.output(16,GPIO.LOW)
GPIO.output(21,GPIO.LOW)
