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
- our ultimate goal is to pull just the CSI out into a matrix so we can pass it on to our CNN (like in SignFi) we have modified packet decode to create a matrix of the CSI as it passes over the receiverd file
- what is the difference between the 1pkt and 1000pkt transmit bit files?
- we are getting the "dropped samples" message a lot on the tx side. is this just the sdrs being finicky? what can cause this?
- 
