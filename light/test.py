import argparse
import asyncio
from kasa import SmartBulb

async def main(ip: str):
    b = SmartBulb(ip)
    
    await b.update()

    colors = [[100, 90, 90], [10, 90, 90], [200, 90, 90]]

    for c in colors:
        await b.set_hsv(*c)
        print(f"setting color to: {c}")
        await asyncio.sleep(1)

if __name__ == "__main__":
    parse = argparse.ArgumentParser('change the colors on the bulb')
    parse.add_argument('ip', type=str)
    args = parse.parse_args()
    asyncio.run(main(args.ip))
