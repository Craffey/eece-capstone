import argparse
from ble import Ble 
import asyncio
import os
from twilio.rest import Client

account_sid = os.environ['TWILIO_ACCOUNT_SID']
auth_token = os.environ['TWILIO_AUTH_TOKEN']

def send_msg(number: str):
    client = Client(account_sid, auth_token)
    message = client.messages \
                    .create(
                         body="INTRUDER ALERT! INTRUDER ALERT!",
                         from_='+14348305485',
                         to=number
                     )
    print(f"msg sid: {message.sid}")

async def amain(args):
    if (args.action == 1):
        await Ble.light_off()
        send_msg('+19174463641')
    elif (args.action == 2):
        await Ble.light_on()

if __name__ == "__main__":
    parse = argparse.ArgumentParser('run a backend')
    parse.add_argument('--action', type=int)
    args = parse.parse_args()
    asyncio.run(amain(args))
