import argparse
from ble import Ble 
import asyncio
import os
import sys
from twilio.rest import Client
from bleak import BleakClient
from magicblue import MagicBlue
from time import sleep

ADDRESS = "F3:BC:6F:03:B5:EE"

LIGHT_CHARACTERISTIC = "932c32bd-0002-47a2-835a-a8d455b859dd"
BRIGHTNESS_CHARACTERISTIC = "932c32bd-0003-47a2-835a-a8d455b859dd"
TEMPERATURE_CHARACTERISTIC = "932c32bd-0004-47a2-835a-a8d455b859dd"
COLOR_CHARACTERISTIC = "932c32bd-0005-47a2-835a-a8d455b859dd"

#account_sid = os.environ['TWILIO_ACCOUNT_SID']
#auth_token = os.environ['TWILIO_AUTH_TOKEN']

#def send_msg(number: str):
#    client = Client(account_sid, auth_token)
#    message = client.messages \
#                    .create(
#                         body="INTRUDER ALERT! INTRUDER ALERT!",
#                         from_='+14348305485',
#                         to=number
#                     )
#    print(f"msg sid: {message.sid}")
#
#async def handle_client(client, reader, writer):
#    print(f"Connected: {client.is_connected}")
#    paired = await client.pair(protection_level=2)
#    print(f"Paired: {paired}")
#
#    print('client connect')
#    request = None
#
#    request = (await reader.read(255)).decode('utf8').strip()
#    response = 'response\n'
#
#    if (request == 'on'):
#        await client.write_gatt_char(LIGHT_CHARACTERISTIC, b"\x01")
#    elif (request == 'off'):
#        await client.write_gatt_char(LIGHT_CHARACTERISTIC, b"\x00")
#    else:
#        response = f'incorrect: {request}'
#        print(response) 
#
#    writer.write(response.encode('utf8'))
#    await writer.drain()
#    writer.close()
#
#async def serv():
#    async with BleakClient(ADDRESS) as client:
#        server = await asyncio.start_server(
#                lambda r, w: handle_client(client, r, w),
#                'localhost', 3333)
#        async with server:
#            await server.serve_forever()
#
#async def client(args):
#    _, writer = await asyncio.open_connection('localhost', 3333)
#    writer.write(args.action.encode('utf8'))
#    writer.close()


if __name__ == "__main__":
    parse = argparse.ArgumentParser('run a backend')
    #parse.add_argument('--server', action='store_true')
    parse.add_argument('--action', type=str, choices=['on', 'off', 'brightness'])
    args = parse.parse_args()

    bulb_mac_address = '98:7b:f3:68:19:93'
    bulb = MagicBlue(bulb_mac_address, 6) # Replace 9 by whatever your version is (default: 7)
    bulb.connect()

    if (args.action == 'on'):
        bulb.set_color([0, 255, 0])         # Set red
    elif (args.action == 'off'):
        bulb.set_color([255, 0, 0])         # Set green

    #if (args.server):
    #    asyncio.run(serv())
    #else:
    #    asyncio.run(client(args))

