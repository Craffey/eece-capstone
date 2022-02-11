# /opt/local/bin/python3.9

# https://pysdr.org/content/usrp.html#receiving
# The following code has the same functionality as recv_num_samps(), 
# in fact it’s almost exactly what gets called when you use the convenience function, 
# but now we have the option to modify the behavior:

import uhd 
import numpy as np
import matplotlib.pyplot as plt

usrp = uhd.usrp.MultiUSRP()

num_samps = 10000 # number of samples received
center_freq = 900e6 # Hz
sample_rate = 1e6 # Hz
gain = 50 # dB

usrp.set_rx_rate(sample_rate, 0)
usrp.set_rx_freq(uhd.libpyuhd.types.tune_request(center_freq), 0)
usrp.set_rx_gain(gain, 0)

# Set up the stream and receive buffer
st_args = uhd.usrp.StreamArgs("fc32", "sc16")
st_args.channels = [0]
metadata = uhd.types.RXMetadata()
streamer = usrp.get_rx_stream(st_args)
recv_buffer = np.zeros((1, 1000), dtype=np.complex64)

# Start Stream
stream_cmd = uhd.types.StreamCMD(uhd.types.StreamMode.start_cont)
stream_cmd.stream_now = True
streamer.issue_stream_cmd(stream_cmd)

# Receive Samples
samples = np.zeros(num_samps, dtype=np.complex64)
for i in range(num_samps//1000):
    streamer.recv(recv_buffer, metadata)
    samples[i*1000:(i+1)*1000] = recv_buffer[0]

# Stop Stream
stream_cmd = uhd.types.StreamCMD(uhd.types.StreamMode.stop_cont)
streamer.issue_stream_cmd(stream_cmd)

print(len(samples))
print(samples[0:10])

# Now save to an IQ file
samples.tofile('samples.iq') # Save to file

### Plotting from the variable ###
# extract real part
x = [ele.real for ele in samples]
# extract imaginary part
y = [ele.imag for ele in samples]
plot1 = plt.figure(1)
plt.plot(x,y,'.')
plt.grid(True)
plt.ylabel('Imaginary')
plt.xlabel('Real')

### Plotting from the file we saved ###
fileSamples = np.fromfile('samples.iq', np.complex64) # Read in file.  We have to tell it what format it is
plot2 = plt.figure(2)
plt.plot(np.real(fileSamples), np.imag(fileSamples), '.')
plt.grid(True)
plt.show()



