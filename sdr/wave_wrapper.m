% Wrapper to call the RX, decode, CNN, and smartdevice controller
% note: make sure TX is running
% note: make sure path contains locations for our custom functions
%   1. invoke the SDR receive to sample IQ into a file
%   2. pass the file to the packet decoder to get the CSI
%   3. pass the CSI to the CNN to classify the captured gesture
%   4. invoke the smartdevice controller to command the corect device

% function call values
device_name = 'b200_mini';
run = 'rxcapture';
txBit_filename = 'TransmitBit_1pckt_July13';
packet_length = 9600;
channel_mapping = 1;
rx_gain = 0;
center_frequency = 900e6;
sample_count = 20e5;

receiver = wave_receiver;
if receiver.radioFound
    % initialize the receiver radio
    count = receiver.init(packet_length, ...
                          channel_mapping, ...
                          rx_gain, ...
                          center_frequency, ...
                          sample_count);


    disp("Press enter to receive start");
    pause;
    disp("stating reception of data")
else
    warning(message('sdru:sysobjdemos:MainLoop'))
end

% loop is number of times to sample a gesture
for i=1:10 
    disp(i);
    rxFilename=strcat('WiFi_', device_name,'_',run, '.mat' );

    % 1. invoke the SDR receive to sample IQ into a file
    receiver.receive(count, ...
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

release(receiver.radio);
