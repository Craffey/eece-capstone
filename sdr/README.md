# Software Defined Radio

The software defined radio component of Wave is what measures the radio signal and extracts the required data.

## Running Scratch Notes

Just writing stuff down as I do it so it can be replicated later on

Hardware:

- Ettus b200 mini SN 31216FC

Software:

- MATLAB Add-ons:
  - WLAN toolbox
  - [Communications toolbox support package for USRP radio](https://www.mathworks.com/hardware-support/usrp.html)
    - selected USB based radio for the 2 hardware options above
- MATLAB code:
  - followed [these steps](https://www.mathworks.com/help/supportpkg/usrpradio/ug/ieee-802-11-tm-wlan-ofdm-beacon-receiver-with-usrp-r-hardware.html) to get a very basic WLAN receiver using the b200 mini
  - [WLAN L-LTF estimation (basic_sim)](https://www.mathworks.com/help/wlan/ref/wlanlltfchannelestimate.html#d123e46192)
    - very basic, hard to transfer to real samples
  - [sdru receiver object](https://www.mathworks.com/help/supportpkg/usrpradio/ug/comm.sdrureceiver-system-object.html#bun592c-29)
      -   when I try to estimate this I get what looks like noise
      -   something to do with the demodulation?
      -   what even *is* the output of of the receiver step function?
  - [Transmission and Reception of an Image Using WLAN Toolbox and a Single USRP E3xx](https://www.mathworks.com/help/supportpkg/usrpembeddedseriesradio/ug/transmission-and-reception-of-an-image-using-wlan-system-toolbox-and-a-single-usrp-e3xx.html)
    - complicated, long, uses a different SDR model with different modules

