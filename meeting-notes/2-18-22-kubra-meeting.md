# Code sanity check meeting with Kubra

kubra, fatema, john, morgan

## Notes

- to fix the underflow, lower masterclockfreq to be just over double the channelbandwidth (right now its 20 but we can make it 10)

- use longer training field to get a less noisy CSI
  - a,g,n all use different lengths, see matlab docs
- make sure captures are labeled with detils of the experiments
- fatema has come code from kubra that can help us with something?