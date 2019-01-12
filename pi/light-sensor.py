import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)

#define the pin that goes to the circuit
pin_to_circuit = 7

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
        current = 8
        last = 8
        while True:
            last = current
            current = round(rc_time(pin_to_circuit), -1)
            try:
                ratio = last / current
            except ZeroDivisionError:
                ratio = 0
            if ratio > 4.5:
                print(current, last)
                print('Switch')
                time.sleep(1.5)
    except KeyboardInterrupt:
        pass
    finally:
        GPIO.cleanup()
