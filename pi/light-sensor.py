import RPi.GPIO as GPIO
import time

from utils import getLog

log = getLog('light_sensor')

GPIO.setmode(GPIO.BCM)

#define the pin that goes to the circuit
pin_to_circuit = 4

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

if __name__ == '__main__':
    try:
        current = 30
        last = 30
        count = 0
        while True:
            current = rc_time(pin_to_circuit) #int(5 * round(float(rc_time(pin_to_circuit)/5)))
            if count == 3:
                #current = round(rc_time(pin_to_circuit), -1)
                try:
                    ratio = last / current
                except ZeroDivisionError:
                    ratio = 1
                print(current, ratio)
                if current - last >= 15: #  ratio < 1 and ratio > .5:
                    print(last, current, ratio)
                    log.info('Light switched')
                    break
                count = 0
                last = current
            else: 
                count += 1
    except KeyboardInterrupt:
        pass
    finally:
        GPIO.cleanup()
