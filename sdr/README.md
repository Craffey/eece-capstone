# Software Defined Radio

The software defined radio component of Wave is what measures the radio signal and extracts the required data.

## Running Scratch Notes

Just writing stuff down as I do it so it can be replicated later on

Hardware:

- Ettus b200 mini SN 31216FC
- Ettus b205 mini

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
  - Python code
    - needs [uhd module.](https://files.ettus.com/manual/page_build_guide.html) Pain to install, I got it working on Mac by following the instructions closely and making sure to run python from the ```port install``` location (/opt/local/bin...)
    - [basic sampling in python](https://pysdr.org/content/usrp.html#software-drivers-install)
    - [fft visualizer](https://kb.ettus.com/Verifying_the_Operation_of_the_USRP_Using_UHD_and_GNU_Radio#Receiving_Samples)
      - ```/opt/local/share/uhd/examples/rx_ascii_art_dft --freq 2.430e9 --rate 60e6 --gain 76 --dyn-rng 80 --bw 5e6 --ref-lvl -20 --frame-rate 5```
      - I was able to pick up on 2.4gHz spikes next to my microwave but could not isolate channels of wifi, seems to just spike at whatever i set the center freq to

