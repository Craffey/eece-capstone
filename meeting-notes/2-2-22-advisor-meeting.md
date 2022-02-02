# Advisor Meeting 2-22-22

Kaushik, John, Julia, Ben, Fatema, Morgan

## Notes

- transmit wifi data frames from an IQ file repeatedly
  - IQ is the complex numbers that make up the most fundamental level of transmission
  - dont worry about timing just send them one after another
  - need to figure out this pipeline
  - need another b200 mini
- wifi frames are sent over a band of frequencies
  - the band is split into subcarriers (52 or something, research uses 30)
- if the research paper is using N frames, MATLAB should have a way to generate N frames
- we can get our hands on an intel 5300 and mimic the research paper
- work on the SDRs in parallel to the intel card
  - get in touch with phd student to learn how to save the 802.11 frams in an IQ file
  - need to figure out what format we need (consult the sign fi paper)
- dont throw out the idea of GNU radio yet
  - it might not be that complicated since we arent doing anything fancy

## Action Items

### John and Julia:

- get a tx rx happening with n frames in MATLAB and 2 SDRs
  - look up 802.11 n WLAN toolbox inside the MATLAB help 
- Seperately, emulate the transmission of wifi frames so we can start correctly formatting the data on the reciver side so it can interconnect with the ML code

### Ben and Fatema

- figure out format of the CSI 
- take the data that the research has and the classifier code from it and make something happen from it

### Morgan

- Google home API exploration

### Kaushik

- talk to people and figure out how we are going to get an 802.11 frame transmitted and received (MATLAB or GNUradio)
- get us another b200 mini
- Old pc to put the intel 5300 in