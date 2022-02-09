# Advisor Meeting 2-9-22

Kaushik, John, Julia, Ben, Fatema, Morgan

## Notes

- kubra can help with the MATLAB scripts for the SDR
  - pipeline to generate 802.11 n frames capture IQ samples and save in a file
  - need code to translate this to CSI
- Get in touch with Kunal.2904@gmail.com who can help with estimmating CSI on a subset of subcarriers
  - [CSIscan: Learning CSI for Efficient Access Point Discovery in Dense WiFi Networks](https://genesys-lab.org/papers/ICNP_PDF-A-1.pdf)
- 


## Action Items

- make the call on MATLAB or GNUradio or whatever
- meet with kubra
  - get opinion on the code we are using and our output

# CSIscan notes
- Goal was to essentially encode extra information by intentionally and systematically perturbing IQ prior to being sent by an AP. Parameters for how signal is perturbed using an FIR filter are known by the AP and receivers, so they can decode the extra information
- Parameters to the FIR are determined by a neural network from IQ samples collected on the channel
- CSI calculated from change in L-LTF field in 52 out of 64 subcarriers (12 null subcarriers)
- It seems like they are changing the CSI phase by +/- 20 or 40 degrees to encode info
- CNN uses training data, most of which is from MATLAB WLAN toolbox
- They have a simulated client 
- Amount of extra information changes dynamically based on channel quality
