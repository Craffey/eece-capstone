% Wrapper to call the RX, decode, CNN, and smartdevice controller
% note: make sure TX is running
% note: make sure path contains locations for our custom functions
%   1. invoke the SDR receive to sample IQ into a file
%   2. pass the file to the packet decoder to get the CSI
%   3. pass the CSI to the CNN to classify the captured gesture
%   4. invoke the smartdevice controller to command the corect device

% function call values
medium='cable';
platform='B200';
device_name='b200_mini';
distance='1ft';
run='rxcapture';
txBit_filename='TransmitBit_1pckt_July13';
packet_length=9600;
channel_mapping=1;
rx_gain=0;
center_frequency=900e6;
sample_count=20e5;

% rx radio config
radioFound = false;
radiolist = findsdru;
for i = 1:length(radiolist)
    if strcmp(radiolist(i).Status, 'Success')
        if strcmp(radiolist(i).Platform, 'B200')
            radio = comm.SDRuReceiver('Platform','B200', ...
                     'SerialNum', radiolist(i).SerialNum);
            radio.MasterClockRate = 20e6; % Need to exceed 5 MHz minimum
            radio.DecimationFactor = 4;         % Sampling rate is 1.92e6
            radio.OutputDataType='double';
            radioFound = true;
            break;
        end
    end
end
len_txWaveform= packet_length;
radio.ChannelMapping = channel_mapping;  % Receive signals from both channels
radio.CenterFrequency =center_frequency; % B210/X310 series center freq
radio.Gain = rx_gain;
radio.SamplesPerFrame = 2*len_txWaveform;
radio.OverrunOutputPort = true;

count=ceil(sample_count/(radio.SamplesPerFrame));
wifi_rx_data=zeros(count*radio.SamplesPerFrame,1);

if radioFound
    disp("Press enter to receive start");

    pause;
    disp("stating reception of data")
else
    warning(message('sdru:sysobjdemos:MainLoop'))
end

for i=1:10 
    disp(i);
    rxFilename=strcat('WiFi_', device_name,'_',run, '.mat' );

    % 1. invoke the SDR receive to sample IQ into a file
    wave_receiver(radio, ...
                 count, ...
                 rxFilename)
    % 2. pass the file to the packet decoder to get the CSI
    [ber, csi]=decode_wifi_packet(rxFilename, txBit_filename, 0, 0, 0);
    if(ber == 0)
        csi=permute(csi, [3, 1, 2]);
        % 3. pass the CSI to the CNN to classify the captured gesture
        disp('calculating the gesture');
        % gesture=wave_cnn(csi);

        % 4. invoke the smartdevice controller to command the corect device
        disp('invoking smart device');
        % !smartdevice_controller.sh gesture;

    else % decode returned error
        disp('Packets are undecodable');
    end
end

release(radio);