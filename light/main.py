import argparse
from action import Action
from color import Color 
from ble import Ble 

class Test(Action):

    def action1(self):
        print("action 1")

    def action2(self):
        print("action 2")

backends = {
        'test': Test,
        'color': Color,
        'ble': Ble,
}

if __name__ == "__main__":
    parse = argparse.ArgumentParser('run a backend')
    parse.add_argument('backend', type=str, choices=['test', 'color', 'ble'])
    parse.add_argument('--action', type=int)

    args = parse.parse_args()

    backend = backends[args.backend]()
    if (args.action == 1):
        backend.action1()
    elif (args.action == 2):
        backend.action2()
