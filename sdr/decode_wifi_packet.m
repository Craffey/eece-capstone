%sample run
% [ber, csi]=decode_wifi_packet('WiFi_cable_B200_b200_mini_1ft_run1', 'TransmitBit_1pckt_July13', 0, 0, 0);
% csi=permute(csi, [3, 1, 2]);

function [BER,csi] = decode_wifi_packet(wifi_rx_data, ...
                                        txBit_filename, ...
                                        showConstellation, ...
                                        showSpectrum, ...
                                        displayFlag)
    csi = zeros(52, 1, 0);
    csi_index = 1;
    rxWaveform=wifi_rx_data;
    load(txBit_filename,'transmitBits'); % Load transmitted bits
    
    BER=0;
    error_number=[];
    % Setup the constellation diagram viewer for equalized WLAN symbols
    if(showConstellation)
        constellation = comm.ConstellationDiagram('Title','Equalized WLAN Symbols',...
                                        'ShowReferenceConstellation',false);
    end

    nonHTcfg = wlanNonHTConfig;
    nonHTcfg.ChannelBandwidth='CBW5'; 
    fs = wlanSampleRate(nonHTcfg);       % Sampling rate
    chanBW='CBW5';
    % Get the required field indices within a PSDU
    indLSTF = wlanFieldIndices(nonHTcfg,'L-STF');
    indLLTF = wlanFieldIndices(nonHTcfg,'L-LTF');
    indLSIG = wlanFieldIndices(nonHTcfg,'L-SIG');
    Ns = indLSIG(2)-indLSIG(1)+1; % Number of samples in an OFDM symbol


    % Setup Spectrum viewer
    if(showSpectrum)
        saScope = dsp.SpectrumAnalyzer('SampleRate',fs,'YLimits',[-120 10]);
        saScope(rxWaveform)
        pause(1);
    end

    
    %rxWaveform = resample(burstCaptures,fs,fs*osf);
    rxWaveformLen = size(rxWaveform,1);
    searchOffset = 0; % Offset from start of the waveform in samples

    % Minimum packet length is 10 OFDM symbols
    lstfLen = double(indLSTF(2)); % Number of samples in L-STF
    minPktLen = lstfLen*5;
    pktInd = 1;
    sr = wlanSampleRate(nonHTcfg); % Sampling rate
    fineTimingOffset = [];
    packetSeq = [];
    %displayFlag = 0; % Flag to display the decoded information
    count=0;
    % Receiver processing
    while (searchOffset + minPktLen) <= rxWaveformLen
        
        try
        
            % Packet detect

            pktOffset = wlanPacketDetect(rxWaveform, chanBW, searchOffset, 0.8);

            % Adjust packet offset
            pktOffset = searchOffset+pktOffset;
            if isempty(pktOffset) || (pktOffset+double(indLSIG(2))>rxWaveformLen)
                if pktInd==1
                    disp('** No packet detected **');
                end
                break;
            end

             % Extract non-HT fields and perform coarse frequency offset correction
            % to allow for reliable symbol timing
            nonHT = rxWaveform(pktOffset+(indLSTF(1):indLSIG(2)),:);
            coarseFreqOffset = wlanCoarseCFOEstimate(nonHT,chanBW);
            nonHT = helperFrequencyOffset(nonHT,fs,-coarseFreqOffset);

            % Symbol timing synchronization
            fineTimingOffset = wlanSymbolTimingEstimate(nonHT,chanBW);

            % Adjust packet offset
            pktOffset = pktOffset+fineTimingOffset;

            % Timing synchronization complete: Packet detected and synchronized
            % Extract the NonHT preamble field after synchronization and
            % perform frequency correction
            if (pktOffset<0) || ((pktOffset+minPktLen)>rxWaveformLen)
                searchOffset = pktOffset+1.5*lstfLen;
                continue;
            end
            
            if(displayFlag)
                fprintf('\nPacket-%d detected at index %d\n',pktInd,pktOffset+1);
            end

            % Extract first 7 OFDM symbols worth of data for format detection and
            % L-SIG decoding
            nonHT = rxWaveform(pktOffset+(1:7*Ns),:);
            nonHT = helperFrequencyOffset(nonHT,fs,-coarseFreqOffset);

            % Perform fine frequency offset correction on the synchronized and
            % coarse corrected preamble fields
            lltf = nonHT(indLLTF(1):indLLTF(2),:);           % Extract L-LTF
            fineFreqOffset = wlanFineCFOEstimate(lltf,chanBW);
            nonHT = helperFrequencyOffset(nonHT,fs,-fineFreqOffset);
            cfoCorrection = coarseFreqOffset+fineFreqOffset; % Total CFO

            % Channel estimation using L-LTF
            lltf = nonHT(indLLTF(1):indLLTF(2),:);
            demodLLTF = wlanLLTFDemodulate(lltf,chanBW);
            chanEstLLTF = wlanLLTFChannelEstimate(demodLLTF,chanBW);
            csi(:, :, csi_index) = chanEstLLTF;
            csi_index = csi_index + 1;

            % Noise estimation
            noiseVarNonHT = helperNoiseEstimate(demodLLTF);

            % Packet format detection using the 3 OFDM symbols immediately
            % following the L-LTF
            format = wlanFormatDetect(nonHT(indLLTF(2)+(1:3*Ns),:), ...
                chanEstLLTF,noiseVarNonHT,chanBW);
            if(displayFlag)
                disp(['  ' format ' format detected']);
            end
            if ~strcmp(format,'Non-HT')
                if(displayFlag)
                    fprintf('  A format other than Non-HT has been detected\n');
                end
                searchOffset = pktOffset+1.5*lstfLen;
                continue;
            end

            % Recover L-SIG field bits
            [recLSIGBits,failCheck] = wlanLSIGRecover( ...
                   nonHT(indLSIG(1):indLSIG(2),:), ...
                   chanEstLLTF,noiseVarNonHT,chanBW);

            if failCheck
                if(displayFlag)
                    fprintf('  L-SIG check fail \n');
                end
                searchOffset = pktOffset+1.5*lstfLen;
                continue;
            else
                if(displayFlag)
                    fprintf('  L-SIG check pass \n');
                end
            end

            % Retrieve packet parameters based on decoded L-SIG
            [lsigMCS,lsigLen,rxSamples] = helperInterpretLSIG(recLSIGBits,sr);

            if (rxSamples+pktOffset)>length(rxWaveform)
                if(displayFlag)
                    disp('** Not enough samples to decode packet **');
                end
                break;
            end

            % Apply CFO correction to the entire packet
            rxWaveform(pktOffset+(1:rxSamples),:) = helperFrequencyOffset(...
                rxWaveform(pktOffset+(1:rxSamples),:),fs,-cfoCorrection);

            % Create a receive Non-HT config object
             rxNonHTcfg = wlanNonHTConfig;
             rxNonHTcfg.ChannelBandwidth='CBW5';
             rxNonHTcfg.MCS = lsigMCS;
             rxNonHTcfg.PSDULength = lsigLen;

            % Get the data field indices within a PPDU
            indNonHTData = wlanFieldIndices(rxNonHTcfg,'NonHT-Data');

            % Recover PSDU bits using transmitted packet parameters and channel
            % estimates from L-LTF
            rxPSDU=[];
            if (lsigMCS==7)
                  [rxPSDU,eqSym] = wlanNonHTDataRecover(rxWaveform(pktOffset+...
                   (indNonHTData(1):indNonHTData(2)),:), ...
                   chanEstLLTF,noiseVarNonHT,rxNonHTcfg);
            end

            if (length(rxPSDU)==8192)
                count=count+1;
                [error_number(count), ~]=biterr(rxPSDU,transmitBits(8192*(count-1)+1:8192*count));
            else
                count=count+1;
                [error_number(count)]=8192;
            end


            if(showConstellation)   
                constellation(reshape(eqSym,[],1)); % Current constellation
                pause(1); % Allow constellation to repaint
                release(constellation); % Release previous constellation plot
            end

            displayExtraFlag=false;
            % Display decoded information
            if displayExtraFlag
                fprintf('  Estimated CFO: %5.1f Hz\n\n',cfoCorrection); %#ok<UNRCH>

                disp('  Decoded L-SIG contents: ');
                fprintf('                            MCS: %d\n',lsigMCS);
                fprintf('                         Length: %d\n',lsigLen);
                fprintf('    Number of samples in packet: %d\n\n',rxSamples);

    %             fprintf('  EVM:\n');
    %             fprintf('    EVM peak: %0.3f%%  EVM RMS: %0.3f%%\n\n', ...
    %             evm.Peak,evm.RMS);
    % 
    %             fprintf('  Decoded MAC Sequence Control field contents:\n');
    %             fprintf('    Sequence number:%d\n',packetSeq(pktInd));

            end
                        
        catch  ME
           if (strcmp(ME.identifier,'MATLAB:catenate:dimensionMismatch'))
              msg = ['Dimension mismatch occurred: First argument has ', ...
                    num2str(size(A,2)),' columns while second has ', ...
                    num2str(size(B,2)),' columns.'];
                causeException = MException('MATLAB:myCode:dimensions',msg);
                ME = addCause(ME,causeException);
           end
           %rethrow(ME)
        end

            % Update search index
            searchOffset = pktOffset+double(indNonHTData(2));
            pktInd = pktInd+1;
            % Finish processing when a duplicate packet is detected. The
            % recovered data includes bits from duplicate frame
            if length(unique(packetSeq))<length(packetSeq)
                break
            end        
    end
    
    if(~isempty(error_number))
        BER=sum(error_number)/(length(error_number)*length(transmitBits));
    else
        if(displayFlag)
            disp('Packets are undecodable');
        end
        BER=-1;
    end    
end
