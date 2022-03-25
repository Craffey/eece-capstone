import argparse
import asyncio
from action import Action
from kasa import SmartBulb

ip = ""

class Color(Action):

    def __init__(self):
        self.b = SmartBulb(ip)

    def action1(self):
        color1 = [100, 90, 90]
        asyncio.run(self.b.set_hsv(color1))

    def action2(self):
        color2 = [200, 90, 90]
        asyncio.run(self.b.set_hsv(color2))

