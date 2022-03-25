import time
import Adafruit_BluefruitLE
import philble.client
from action import Action

class Ble(Action):

    def __init__(self):
        ble = Adafruit_BluefruitLE.get_provider()
        ble.initialize()

        ble.clear_cached_data()

        adapter = ble.get_default_adapter()
        adapter.power_on()
        adapter.start_scan()
        device = ble.find_device()
        device.connect()
        self.client = philble.client.Client(device)
        adapter.stop_scan()

    def action1(self):
        self.client.power(True)

    def action2(self):
        print("action 2")
