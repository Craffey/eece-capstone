% Basic simulation of channel estimation 
%  Generate a time domain waveform for an 802.11n HT packet
 
cfgHT = wlanHTConfig; % Create packet configuration
txWaveform = wlanWaveformGenerator([1;0;0;1],cfgHT);
scatterplot(txWaveform);
grid;
  
%       Multiply the transmitted VHT signal by -0.1 + 0.5i 
% and pass it through an AWGN channel with a 30 dB signal-to-noise ratio
rxWaveform = awgn(txWaveform*(-0.1+0.5i),30);
  
%         Extract L-LTF and perform channel estimation without frequency
%         smoothing
idxLLTF = wlanFieldIndices(cfgHT,'L-LTF');
demodSig = wlanLLTFDemodulate(rxWaveform(idxLLTF(1):idxLLTF(2),:),cfgHT);
scatterplot(demodSig);
grid;
est = wlanLLTFChannelEstimate(demodSig,cfgHT);
scatterplot(est);
grid;