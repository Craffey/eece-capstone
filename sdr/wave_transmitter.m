%sample to run
% transmitter = wave_transmitter(900e6, 1, 70);
% transmitter.transmit('mcs7.mat', false, 10);
% For long packet run 'WiFi_80211a_long', true, 30 

% Select tx_gain 70 for B210, 72 for B210, 0 for X310, 8 for N210.
classdef wave_transmitter
    
    properties
        radio;
        radioFound;
    end
    
    methods
        % constructor and radio initialize
        function self = wave_transmitter(center_frequency, ...
                                channel_mapping, ...
                                tx_gain)
            radioFound = false;
            radiolist = findsdru;
            for i = 1:length(radiolist)
                if strcmp(radiolist(i).Status, 'Success')
                    if (strcmp(radiolist(i).Platform, 'B200'))
                        self.radio = comm.SDRuTransmitter('Platform','B200', ...
                                'SerialNum', radiolist(i).SerialNum);
                        self.radio.MasterClockRate = 20e6; 
                        self.radio.InterpolationFactor = 4;     
                        radioFound = true;
                        break;
                    end
                end
            end 
        
            if ~radioFound
                error(message('sdru:examples:NeedMIMORadio'));
            end
            
            self.radio.ChannelMapping = channel_mapping;
            self.radio.CenterFrequency = center_frequency; % For B210
            self.radio.Gain =tx_gain;
            self.radio.UnderrunOutputPort = true;
            self.radio.EnableBurstMode=false;
        end

        % Transmit for tx_timecount loops
        function transmit(self, WiFi_packet_filename, isLongPacket, tx_timecount)
            load(WiFi_packet_filename, 'txWaveform');
            % Scale the normalized signal to avoid saturation of RF stages
            powerScaleFactor = 0.8;
            txWaveform = txWaveform.*(1/max(abs(txWaveform))*powerScaleFactor);
            % Cast the transmit signal to int16, this is the native format for the SDR
            % hardware
            txWaveform = int16(txWaveform*2^15);

            disp('Press enter to start transmission');
            pause;

            disp('started transmission');

            if(isLongPacket)    
                for j=1:tx_timecount    
                    for i=1:375000:length(txWaveform)
                        if(i+374999 > length(txWaveform))
                            last_i = length(txWaveform) - i;                    
                        else
                            last_i = i+374999;                    
                        end
                        bufferUnderflow = step(self.radio,txWaveform(i:last_i));
                        if bufferUnderflow~=0
                            warning('sdru:examples:DroppedSamples','Dropped samples')
                        end
                    end
                end
            else
                for j=1:tx_timecount
                    for i=1:100        
                        bufferUnderflow = step(self.radio,txWaveform);        
                        if bufferUnderflow~=0
                            warning('sdru:examples:DroppedSamples','Dropped samples')
                        end                 
                    end
                end   
            end
        end
    end
end
