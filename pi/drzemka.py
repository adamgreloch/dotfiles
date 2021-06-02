import time
from gpiozero import LED

led = LED(22)

while True:
    if int(time.strftime("%H")) in range(7, 22):
        led.on()
    else:
        led.off()
    time.sleep(300)

