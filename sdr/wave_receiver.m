% setup and call to this is in wave wrapper
% receiver = wave_receiver;
% count = receiver.init(packet_length, ...
%                           channel_mapping, ...
%                           rx_gain, ...
%                           center_frequency, ...
%                           sample_count);
% receiver.receive(count, ...
%                     rxFilename)

classdef wave_receiver
    
    properties
        radio;
        radioFound;
    end
    
    methods
        % constructor
        function self = wave_receiver(~)
            
            % rx radio config
            self.radioFound = false;
            radiolist = findsdru;
            for i = 1:length(radiolist)
                if strcmp(radiolist(i).Status, 'Success')
                    if strcmp(radiolist(i).Platform, 'B200')
                        self.radio = comm.SDRuReceiver('Platform','B200', ...
                                 'SerialNum', radiolist(i).SerialNum);
                        self.radio.MasterClockRate = 20e6; % Need to exceed 5 MHz minimum
                        self.radio.DecimationFactor = 4;   % Sampling rate is 1.92e6
                        self.radio.OutputDataType='double';
                        self.radioFound = true;
                        break;
                    end
                end
            end
        end
        
        % initialize the sdr
        function count = init(self,...
                              packet_length, ...
                              channel_mapping, ...
                              rx_gain, ...
                              center_frequency, ...
                              sample_count)
                          
            len_txWaveform= packet_length;
            self.radio.ChannelMapping = channel_mapping;  % Receive signals from both channels
            self.radio.CenterFrequency =center_frequency; % B210/X310 series center freq
            self.radio.Gain = rx_gain;
            self.radio.SamplesPerFrame = 2*len_txWaveform;
            self.radio.OverrunOutputPort = true;

            count=ceil(sample_count / (self.radio.SamplesPerFrame));
        end
        
        % recive samples from the radio and store in a file
        function receive(self, ...
                         count, ...
                         fname)
                     
              % Loop until the example reaches the target stop time, which is 10 sec
              wifi_rx_data=zeros(count * self.radio.SamplesPerFrame, 1);
              timeCounter = 1;
              while timeCounter < count+1
                [x, len] = step(self.radio);
                if len >= 9600
                  wifi_rx_data((timeCounter-1)*length(x)+1:timeCounter*length(x))=x;
                  timeCounter = timeCounter + 1;
                end
              end
            save (fname, 'wifi_rx_data');
        end
    end
end
