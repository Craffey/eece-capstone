import argparse
import asyncio
from magicblue import MagicBlue

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

async def handle_client(bulb, reader, writer):
    request = None

    request = (await reader.read(255)).decode('utf8').strip()
    response = 'response\n'

    if (request == 'on'):
        print("on")
        bulb.set_color([0, 255, 0])         # Set red
    elif (request == 'off'):
        print("off")
        bulb.set_color([255, 0, 0])         # Set green
    else:
        response = f'incorrect: {request}'
        print(response) 

    writer.write(response.encode('utf8'))
    await writer.drain()
    writer.close()

async def serv():
    bulb_mac_address = '98:7b:f3:68:19:93'
    bulb = MagicBlue(bulb_mac_address, 6) # Replace 9 by whatever your version is (default: 7)
    bulb.connect()
    print("connected")

    server = await asyncio.start_server(
            lambda r, w: handle_client(bulb, r, w),
            'localhost', 3333)
    async with server:
        await server.serve_forever()
        bulb.disconnect()

async def client(args):
    _, writer = await asyncio.open_connection('localhost', 3333)
    writer.write(args.action.encode('utf8'))
    writer.close()


if __name__ == "__main__":
    parse = argparse.ArgumentParser('run a backend')
    parse.add_argument('--server', action='store_true')
    parse.add_argument('--action', type=str, choices=['on', 'off', 'brightness'])
    args = parse.parse_args()

    if (args.server):
        asyncio.run(serv())
    else:
        asyncio.run(client(args))

