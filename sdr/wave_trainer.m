% Wrapper to call the RX, decode, CNN, and smartdevice controller
% note: make sure TX is running
% note: make sure path contains locations for our custom functions
%   1. invoke the SDR receive to sample IQ into a file
%   2. pass the file to the packet decoder to get the CSI
%   3. pass the training CSI to the CNN to train the gesture
% example usage wave_trainer(5,'wave','between','1ft')

function [training_csi] = wave_trainer(captures, ... number of times to capture the gesture
                    gesture_name, ... name of the gesture
                    gesture_location, ... where in relation to antenna gesture is
                    distance) % distance between antennas
                    
    % these things stay the same between experiments
    device_name = 'b200_mini';
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
        % extra dimmension on the CSI for each capture of the gesture
        % 52 subcarriers captured by channelest, can scale back after if we
        % only want to hand over a certain amount
        training_csi = zeros(2*count, 52, captures);
    
        disp("Press enter to receive start");
        pause;
        disp("stating reception of data")
    else
        warning(message('sdru:sysobjdemos:MainLoop'))
    end
    % loop is number of times to sample a gesture
    for run=1:captures 
        disp(run);
        % file name
        rxFilename=strcat(device_name, '_',gesture_name,'_', distance, '_', ...
                    gesture_location, '_', num2str(run), '.mat' );
        % 1. invoke the SDR receive to sample IQ into a file
        receiver.receive(count, ...
                        rxFilename)
        % 2. pass the file to the packet decoder to get the CSI
        [ber, csi]=decode_wifi_packet(rxFilename, txBit_filename, 0, 0, 0);
        if(ber == 0)
            csi=permute(csi, [3, 1, 2]);
            % append data
            % TODO make it so we only give the first 200 (or whatever)
            % samples to the training csi matrix so we guarantee allignment
            % and can pass to CNN
            training_csi(:,:,run) = csi;
        else % decode returned error
            disp('Packets are undecodable');
        end
    end
    % 3. pass the training CSI to the CNN to train the gesture
    disp(strcat('training ' , gesture_name));
    % wave_cnn_trainer(training_csi);

    release(receiver.radio);
end
