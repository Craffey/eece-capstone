# 1/25/2022 team meeting

John, Julia, Ben, Fatema, Morgan

## Notes

- Decided on using [SignFi](https://dl.acm.org/doi/10.1145/3191755)
    - Dataset can be found [here](https://github.com/yongsen/SignFi)
    - Collected using [Linux 802.11n CSI Tool](http://dhalperi.github.io/linux-80211n-csitool/)
- Options to deal with the frequency issue that came up in the SDR meeting
    - Use the existing datasets to create framework of ML model then Re-train with data at compatible frequency
    - Find a way to work at the frequencies in the papers
    - For now, make the ML model assuming we can match the frequencies and work from the ground up on the radio; converge later and readjust strategy

## Questions:
Frequency issue, interference, maybe need to find a channel no one is using? (5GHz ch95) What is your recommendation?
Is there a router we can use in your lab?
Data collection? Intel 5300 NIC (last time he said they don’t have a laptop)
