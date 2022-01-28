# 1/19/2022 Advisor Meeting

Kaushik, John, Julia, Ben, Fatema, Morgan

## Notes

- can use matlab to send continuous transmission of wifi frames but wont actaully be following the timing of wifi like in gnu radio or with an actual router
  - can also use matlab for the ML and keep it all in one unit
  - to find a freq we want (specific channel) we can do a scan
    - a COTS router when setup does a self scan and picks a channel that it sees less activity on
      - it can also be forced to one
    - surrounding environment affects CSI
    - **solution** use an unlicenced (900MHZ)
- training data from the papers is pretty much guaranteed to not transfer over so we are going to need to create our own.
  - use training data to get the framework of ML model

- dates and updates into he general teams chat
- next week meeting in ISEC 523


## Action Items

Ben and Fatema:

- start borrowing code from the papers
- find the starting point 
  - (what does the matlab need to produce IQ samples, CSI ?)

John and Julia:

- Get matlab running + simulations, get radios from fatema / kaushik
- when installing MATLAB, [run spectrum anylyzer](https://www.mathworks.com/help//supportpkg/rtlsdrradio/ug/spectral-analysis-with-rtl-sdr-radio.html) on the SDR and get a feel on what freqs we want to use
- fatema has an SDR we can use to get going (b200 mini)

Morgan:

- exploring smart devices
- look into [matlab thingspeak](https://www.mathworks.com/products/thingspeak.html)
