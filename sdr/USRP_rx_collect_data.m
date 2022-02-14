
%sample to run the function
%USRP_rx_collect_data(900e6,1, 0,9600, 20e6, 'B200', 'b200_mini', 'cable', '1ft', 'run1'); 


function USRP_rx_collect_data(center_frequency, channel_mapping, rx_gain, packet_length, sample_count, platform, device_name, medium, distance, run )
 
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
            if (strcmp(radiolist(i).Platform, 'X300') || ...
                strcmp(radiolist(i).Platform, 'X310'))
                radio = comm.SDRuReceiver('Platform',radiolist(i).Platform, ...
                         'IPAddress', radiolist(i).IPAddress);
                radio.MasterClockRate = 184.32e6;
                radio.DecimationFactor = 96;        % Sampling rate is 1.92e6
                radioFound = true;
            end
        end
    end
    
    len_txWaveform= packet_length;
    radio.ChannelMapping = channel_mapping;     % Receive signals from both channels
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
      % Loop until the example reaches the target stop time, which is 10
      % seconds.
      timeCounter = 1;
      while timeCounter < count+1
        [x, len] = step(radio);
        if len >= 9600
          wifi_rx_data((timeCounter-1)*length(x)+1:timeCounter*length(x))=x;
          timeCounter = timeCounter + 1;
        end
      end

    else
        warning(message('sdru:sysobjdemos:MainLoop'))
    end
    
    fname=strcat('WiFi_', medium, '_',  platform, '_', device_name, '_', distance,'_',run, '.mat' );
    
    save (fname, 'wifi_rx_data');
    
    release(radio);
end