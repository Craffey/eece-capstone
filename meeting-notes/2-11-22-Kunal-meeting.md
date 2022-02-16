# Software pipeline Meeting 2-11-22

Kunal, John, Julia, Ben, Morgan

## Notes

2 ways to collect dataset

1. use the CSI tool and the wifi card
   - Kunal hasnt tried this
   - once its configured you can capture packets

kunal has scripts to do the transmit and the receive

1. Transmit same wifi frame repeatedly
2. receive frames and save to file (do this in pulses, really hard to work with the USRP live in real-time)
3. get CSI with matlab script, save with folder structure that labels the gestures


## Questions for kunal in next meeting

- we have the TX, RX, decode working with our SDRs and the files provided
- our ultimate goal is to pull just the CSI out into a matrix so we can pass it on to our CNN (like in SignFi)
  - what is the difference between the 1pkt and 1000pkt transmit bit files?
  - we need the CSI asap since our system is real-time, but the packet decode is slow (specifically the line for detection of packets). Is there any way to get the CSI without decoding the entirety of the packet? or should we just collect less samples?
  - packet decode does channel estimation but doesnt save it anywhere
