% Wrapper to call the RX, decode, CNN, and smartdevice controller
% note: make sure TX is running
% note: make sure path contains locations for our custom functions
%   1. invoke the SDR receive to sample IQ into a file
%   2. pass the file to the packet decoder to get the CSI
%   3. pass the CSI to the CNN to classify the captured gesture
%   4. invoke the smartdevice controller to command the corect device

%use to enable and disable heatmap output
heat_on = 1;

% function call values
device_name = 'b200_mini';
run = 'rxcapture';
txBit_filename = 'TransmitBit_1pckt_July13';
packet_length = 9600;
channel_mapping = 1;
rx_gain = 0;
center_frequency = 900e6;
sample_count = 20e5;
csi_4d = zeros(200, 52, 1, 1);

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
for i=1:100
    disp(i);
    %rxFilename=strcat('WiFi_', device_name,'_',run, '.mat' );

    % 1. invoke the SDR receive to sample IQ into a file
    rx_wifi_data = receiver.receive(count);
    % 2. pass the file to the packet decoder to get the CSI
    disp('Received packet, decoding...');
    [ber, csi]=decode_wifi_packet(rx_wifi_data, txBit_filename, 0, 0, 0);
    if(ber == 0)
        csi=permute(csi, [3, 1, 2]);
        if (length(csi) < 200)
            warning('csi came back with less than 200 samples');
            continue
        end
        
        csi_4d(:, :, 1, 1) = csi(1:200, :);
        csi_4d(:, :, 1, 2) = csi(1:200, :);
        
        csi_abs = normalize(abs(csi_4d));
        csi_ang = angle(csi_4d);
        csi_tensor = [csi_abs,csi_ang];
        
        % 2.5 display heatmap
        if (heat_on)
            xvalues = 1:200;
            yvalues = 1:52;

            amp1 = permute(normalize(abs(csi(1:200,:))), [2 1]);
            ang1 = permute(angle(csi(1:200,:)), [2 1]);

            % create amplitude heatmap
            subplot(2, 1, 1);
            h1 = heatmap(xvalues,yvalues,amp1);
            h1.Title = 'CSI amplitude';
            h1.XLabel = 'Packet Num';
            h1.YLabel = 'subcarrier';

            % create phase heatmap
            subplot(2, 1, 2);
            h2 = heatmap(xvalues,yvalues,ang1);
            h2.Title = 'CSI phase';
            h2.XLabel = 'Packet Num';
            h2.YLabel = 'subcarrier';
        end

        % 3. pass the CSI to the CNN to classify the captured gesture
        disp('calculating the gesture');
        [gesture,err] = classify(net, csi_tensor);
        
        fprintf('Gesture %d\n', gesture(1));

        % 4. invoke the smartdevice controller to command the corect device
%         disp('invoking smart device');
        % !smartdevice_controller.sh gesture;

    else % decode returned error
        disp('Packets are undecodable');
    end
end

release(receiver.radio);
