from magicblue import MagicBlue
from time import sleep

bulb_mac_address = '98:7b:f3:68:19:93'
bulb = MagicBlue(bulb_mac_address, 6) # Replace 9 by whatever your version is (default: 7)
bulb.connect()
bulb.set_color([255, 0, 0])         # Set red
sleep(5)
bulb.set_color([0, 255, 0])

