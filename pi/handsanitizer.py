import RPi.GPIO as GPIO
import time
from flask import Flask, request
import threading

from utils import getLog
log = getLog('hand_sanitizer')

app = Flask(__name__)

# set up IO pins for led
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(21, GPIO.OUT)
GPIO.setup(20, GPIO.OUT)
GPIO.setup(16, GPIO.OUT)

pin_to_circuit = 4 # pin for light sensor

@app.route('/handsanitizer', methods = ['POST'])
def handsanitizer():
    '''
    if request.args['ipad'] != 'init':
        log.error('Request sent from bad source')
        raise 'Request sent from source other that known iPad'
    '''
    ledOn()
    
    thread = threading.Thread(target = checkLight)
    thread.start()
    
    return 'success'

def ledOn():
    log.info('LED on')
    GPIO.output(21, GPIO.HIGH)
    GPIO.output(20, GPIO.HIGH)
    GPIO.output(16, GPIO.HIGH)

def ledOff():
    log.info('LED off')
    GPIO.output(21, GPIO.LOW)
    GPIO.output(20, GPIO.LOW)
    GPIO.output(16, GPIO.LOW)

def rc_time(pin_to_circuit):
    count = 0
          
    #Output on the pin for 
    GPIO.setup(pin_to_circuit, GPIO.OUT)
    GPIO.output(pin_to_circuit, GPIO.LOW)
    time.sleep(0.1)

    #Change the pin back to input
    GPIO.setup(pin_to_circuit, GPIO.IN)
                                    
    #Count until the pin goes high
    while GPIO.input(pin_to_circuit) == GPIO.LOW:
        count += 1
    return count

def checkLight():
    try:
        current = 8
        last = 8
        while True:
            last = current
            current = round(rc_time(pin_to_circuit), -1)
            try:
                ratio = last / current
            except ZeroDivisionError:
                ratio = 0
            if ratio > 2:
                log.info('Light switched')
                break
    except KeyboardInterrupt:
        pass
    finally:
        ledOff()

@app.errorhandler(404)
def error(e):
    return 'Something went wrong!'

if __name__ == '__main__':
    try:
        log.info('Starting Handsanitizer API')
        app.run(host = '0.0.0.0')
    except:
        log.exception('Error in main')
    finally:
        log.info('Closing Handsanitizer API')
