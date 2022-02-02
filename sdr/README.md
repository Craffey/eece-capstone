# Software Defined Radio

The software defined radio component of Wave is what measures the radio signal and extracts the required data.

## Running Scratch Notes

Just writing stuff down as I do it so it can be replicated later on

Hardware:

- Ettus b200 mini (fatema has)
- Ettus b210 (kaushik has)

Software:

- MATLAB Add-ons:
  - WLAN toolbox
  - [Communications toolbox support package for USRP radio](https://www.mathworks.com/hardware-support/usrp.html)
    - selected USB based radio for the 2 hardware options above
- MATLAB code:
  - followed [these steps](https://www.mathworks.com/help/supportpkg/usrpradio/ug/ieee-802-11-tm-wlan-ofdm-beacon-receiver-with-usrp-r-hardware.html) to get a very basic WLAN receiver using the b200 mini
