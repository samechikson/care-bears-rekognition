import evdev

device = evdev.InputDevice('/dev/input/by-id/usb-BarCode_WPM_USB-event-kbd')
letters = {1: '^', 2: '1', 3: '2', 4: '3', 5: '4', 6: '5', 7: '6', 8: '7', 9: '8', 10: '9', 
          11: '0', 16: 'q', 17: 'w', 18: 'e', 19: 'r', 20: 't', 21: 'z', 22: 'u', 23: 'i', 
          24: 'o', 25: 'p', 30: 'a', 31: 's', 32: 'd', 33: 'f', 34: 'g', 35: 'h', 36: 'j', 
          37: 'k', 38: 'l', 44: 'y', 45: 'x', 46: 'c', 47: 'v', 48: 'b', 49: 'n', 50: 'm'}

code = ''
for event in device.read_loop():
    # 28 == enter 
    if event.code == 28 and event.value == 1:
        # enter key is released
        print(code)
        code = ''
    if event.type == 1 and event.value == 1:
        try:
            code += letters[event.code]
        except KeyError:
            pass
