# 1/25 SDR Meeting

John, Julia, Subhro

## Notes

- Start with simulations in Matlab then move onto real setup

- Learn frame structure of wifi packets so we know what to extract from the signal
  - Preamble of the frame has the important info (different for different protocols, a b AC etc)
  - L-STF and L-LTF are the things we will probably be looking at, L-LTF will contain the CSI
    - Read up on these
    - Using the LTF we can estimate the channel
- pN sequences (pseudorandom number)
    - Inside the LTF field
    - Help us estimate the channel that the packet has gone through in the transmission process
    - Channel estimation is how we determine the CSI
- Moving on to GNU radio
    - The basic transceiver can be pulled from GitHub
    - More complex than doing it on Matlab
    - We should work in a lower freq that has no noise and interference
        - **Problematic!** cannot use a router, have to use a transmitter with a set freq?
        - Subhro says the CSI capture will transfer over to higher freqs if we can get it working on a lower one **but** Idk if our ML model will transfer over
        - In theory its possible if we ran in the 5GHz range on a channel number that is unused on northeastern campus
    - Lots of blocks in GNU radio to deal with processing the radio signal
        - The frame processing block that does the channel estimation is written as a  python script
- Could also just do everything in MATLAB, just might run into issues with the closed source nature of it.
    - If we want to use better channel estimation algorithms etc. it will be difficult in Matlab vs GNU radio

## Links

[WiFi Frame Structure](https://www.mathworks.com/help/wlan/gs/wlan-ppdu-structure.html)

[PN Sequence](https://www.mathworks.com/help/comm/ref/comm.pnsequence-system-object.html)
 
[Channel estimation theory](https://www.eurasip.org/Proceedings/Ext/WSA2009/manuscripts/7723.pdf)

[WiFi channel estimation in matlab](https://www.mathworks.com/help/wlan/ref/wlanvhtltfchannelestimate.html)

[SDR radio interfacing with matlab](https://www.mathworks.com/discovery/sdr.html)

[SDR receiver function in matlab](https://www.mathworks.com/help/supportpkg/usrpradio/ug/comm.sdrureceiver-system-object.html)

[wireless transceiver implementation with sdr example matlab](https://www.mathworks.com/content/dam/mathworks/white-paper/wireless-transceiver-hardware-implementation-application-note.pdf)

[Gnuradio install documentation](https://kb.ettus.com/Building_and_Installing_the_USRP_Open-Source_Toolchain_(UHD_and_GNU_Radio)_on_Linux)

[Github repo for wifi transceiver example in gnuradio](https://github.com/bastibl/gr-ieee802-11)
