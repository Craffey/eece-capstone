function encode_wifi_packet(numPackets, tx_bit_filename, wifi_packet_filename)
    nonHTcfg = wlanNonHTConfig;
    nonHTcfg.NumTransmitAntennas = 1;
    nonHTcfg.ChannelBandwidth='CBW5';
    nonHTcfg.MCS = 3;
    nonHTcfg.PSDULength = 1024;
    chanBW='CBW5';
    fs = wlanSampleRate(nonHTcfg);       % Sampling rate
    
    lstf = wlanLSTF(nonHTcfg);
    lltf = wlanLLTF(nonHTcfg);
    lsig = wlanLSIG(nonHTcfg);
    preamble = [lstf;lltf;lsig];
    
    rng(0) % Initialize the random number generator    
    txWaveform = [];
    transmitBits=[];
    for k=1:numPackets
        txPSDU = randi([0 1],nonHTcfg.PSDULength*8,1); % Generate PSDU data in bits
        transmitBits=[transmitBits;txPSDU ];
        data = wlanNonHTData(txPSDU,nonHTcfg);
        txWaveform = [txWaveform;preamble;data];
    end
    save(tx_bit_filename,'transmitBits');
    save(wifi_packet_filename, 'txWaveform');
end
