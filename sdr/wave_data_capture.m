% Wrapper to call the RX, decode, CNN, and smartdevice controller
% note: make sure TX is running
% note: make sure path contains locations for our custom functions
%   1. invoke the SDR receive to sample IQ into a file
%   2. pass the file to the packet decoder to get the CSI
%         append the csi data to csi matrix with extra dimmension
%   3. save the training_csi to a file
% example usage wave_data_capture(5,'wave','between','1ft')

function [training_csi] = wave_data_capture(captures, ... number of times to capture the gesture
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
    rxFilenames = string([]);

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
        training_csi = zeros(200, 52, captures);
    
        disp("Press enter to receive start");
        pause;
        disp("starting reception of data")
    else
        warning(message('sdru:sysobjdemos:MainLoop'))
    end
    rx_wifi_iq_captures = {captures};
    % loop is number of times to sample a gesture
    run = 1;
    while (run <= captures)
        fprintf('attempting run number %d\n', run);
        % file name
        %rxFilenames(run)=strcat('iq/', device_name, '_',gesture_name,'_', distance, '_', ...
                    %gesture_location, '_', string(run), '.mat' );
        % 1. invoke the SDR receive to sample IQ into a file
        rx_wifi_iq = receiver.receive(count);
        % store capture as cell in cell array with all data
        rx_wifi_iq_captures{run} = rx_wifi_iq;
        run = run + 1;
    end
    parfor run = 1:captures
        % 2. pass the file to the packet decoder to get the CSI
        fprintf('decoding packet %d\n',run);
        [ber, csi]=decode_wifi_packet(rx_wifi_iq_captures{run}, txBit_filename, 0, 0, 0);
        if(ber == 0)
            csi=permute(csi, [3, 1, 2]);
            % append data
            if (length(csi) >= 200)
                training_csi(:,:,run) = csi(1:200,:);
            else
                warning('csi came back with less than 200 samples');
            end
        else % decode returned error
            disp('Packets are undecodable');
        end
    end
    % 3. save the training_csi to a file
    csiFilename = strcat(regexprep(datestr(datetime), '(\s|:)+', '_'), ...
                    '_', gesture_name,'_', distance, '_', ...
                    gesture_location, '_csi_data.mat' );
    save (csiFilename, 'training_csi');

    release(receiver.radio);
end
