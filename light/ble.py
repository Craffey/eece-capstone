import sys
import asyncio
from bleak import BleakClient

ADDRESS = "F3:BC:6F:03:B5:EE"

LIGHT_CHARACTERISTIC = "932c32bd-0002-47a2-835a-a8d455b859dd"
BRIGHTNESS_CHARACTERISTIC = "932c32bd-0003-47a2-835a-a8d455b859dd"
TEMPERATURE_CHARACTERISTIC = "932c32bd-0004-47a2-835a-a8d455b859dd"
COLOR_CHARACTERISTIC = "932c32bd-0005-47a2-835a-a8d455b859dd"


class Ble():

    @staticmethod
    async def light_off():
        async with BleakClient(ADDRESS) as client:
            print(f"Connected: {client.is_connected}")
            paired = await client.pair(protection_level=2)
            print(f"Paired: {paired}")

            print("Turning Light off...")
            await client.write_gatt_char(LIGHT_CHARACTERISTIC, b"\x00")

    @staticmethod
    async def light_on():
        async with BleakClient(ADDRESS) as client:
            print(f"Connected: {client.is_connected}")
            paired = await client.pair(protection_level=2)
            print(f"Paired: {paired}")

            print("Turning Light off...")
            await client.write_gatt_char(LIGHT_CHARACTERISTIC, b"\x01")

    @staticmethod
    async def brightness(value):
        async with BleakClient(ADDRESS) as client:
            print(f"Connected: {client.is_connected}")
            paired = await client.pair(protection_level=2)
            print(f"Paired: {paired}")
            await client.write_gatt_char(
                        BRIGHTNESS_CHARACTERISTIC,
                        bytearray([value]),
                )
