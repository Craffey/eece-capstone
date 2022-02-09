% Basic RX of channel estimation 
  
  cfgHT = wlanHTConfig;

%   receive a signal
        rx = comm.SDRuReceiver(...
              'Platform','B200', ...
              'SerialNum','31216FC', ...
              'CenterFrequency', 900e6, ...%2.432e9, ... % Channel 5
              'OutputDataType', 'double', ...
              'MasterClockRate',56e6, ...
              'DecimationFactor',256);
        [rxWaveform, len, over] = rx();
        scatterplot(rxWaveform);
        grid;
  
%         Extract L-LTF and perform channel estimation without frequency
%         smoothing
idxLLTF = wlanFieldIndices(cfgHT,'L-LTF');
demodSig = wlanLLTFDemodulate(rxWaveform(idxLLTF(1):idxLLTF(2),:),cfgHT);
est = wlanLLTFChannelEstimate(demodSig,cfgHT);

scatterplot(est);
grid;