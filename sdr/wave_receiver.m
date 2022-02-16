% setup and call to this is in wave wrapper

function wave_receiver(radio, ... comm.sdrureceiver object
                    count, ...
                    fname )
      % Loop until the example reaches the target stop time, which is 10
      % seconds.
      wifi_rx_data=zeros(count*radio.SamplesPerFrame,1);
      timeCounter = 1;
      while timeCounter < count+1
        [x, len] = step(radio);
        if len >= 9600
          wifi_rx_data((timeCounter-1)*length(x)+1:timeCounter*length(x))=x;
          timeCounter = timeCounter + 1;
        end
      end
    save (fname, 'wifi_rx_data');
end
