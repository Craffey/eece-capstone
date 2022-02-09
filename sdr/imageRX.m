deviceNameSDR = 'B200';

txGain = 10;

% Input an image file and convert to binary stream
fileTx = 'peppers.png';            % Image file name
fData = imread(fileTx);            % Read image data from file
scale = 0.2;                       % Image scaling factor
origSize = size(fData);            % Original input image size
scaledSize = max(floor(scale.*origSize(1:2)),1); % Calculate new image size
heightIx = min(round(((1:scaledSize(1))-0.5)./scale+0.5),origSize(1));
widthIx = min(round(((1:scaledSize(2))-0.5)./scale+0.5),origSize(2));
fData = fData(heightIx,widthIx,:); % Resize image
imsize = size(fData);              % Store new image size
txImage = fData(:);


msduLength = 2304; % MSDU length in bytes
numMSDUs = ceil(length(txImage)/msduLength);
padZeros = msduLength-mod(length(txImage),msduLength);
txData = [txImage; zeros(padZeros,1)];
txDataBits = double(reshape(de2bi(txData, 8)', [], 1));

% Divide input data stream into fragments
bitsPerOctet = 8;
data = zeros(0, 1);

for ind=0:numMSDUs-1

    % Extract image data (in octets) for each MPDU
    frameBody = txData(ind*msduLength+1:msduLength*(ind+1),:);

    % Create MAC frame configuration object and configure sequence number
    cfgMAC = wlanMACFrameConfig('FrameType', 'Data', 'SequenceNumber', ind);

    % Generate MPDU
    [mpdu, lengthMPDU] = wlanMACFrame(frameBody, cfgMAC);

    % Convert MPDU bytes to a bit stream
    psdu = reshape(de2bi(hex2dec(mpdu), 8)', [], 1);

    % Concatenate PSDUs for waveform generation
    data = [data; psdu]; %#ok<AGROW>

end

nonHTcfg = wlanNonHTConfig;         % Create packet configuration
nonHTcfg.MCS = 6;                   % Modulation: 64QAM Rate: 2/3
nonHTcfg.NumTransmitAntennas = 1;   % Number of transmit antenna
chanBW = nonHTcfg.ChannelBandwidth;
nonHTcfg.PSDULength = lengthMPDU;   % Set the PSDU length

sdrTransmitter = comm.SDRuTransmitter( ...
    'Platform', deviceNameSDR, ...
    'SerialNum', '31216FC'); % Transmitter properties

% Resample the transmit waveform at 30MHz
fs = wlanSampleRate(nonHTcfg); % Transmit sample rate in MHz
osf = 1.5;                     % OverSampling factor

% sdrTransmitter.BasebandSampleRate = fs*osf; % FIXME SDRuTransmitter
% object doesnt have this field
sdrTransmitter.CenterFrequency = 2.432e9;  % Channel 5
sdrTransmitter.Gain = txGain;
sdrTransmitter.ChannelMapping = 1;         % Apply TX channel mapping
% sdrTransmitter.ShowAdvancedProperties = true; % FIXME Unrecognized 
% property 'ShowAdvancedProperties' for class 'comm.SDRuTransmitter'
% sdrTransmitter.BypassUserLogic = true; % FIXME same thing


sdrReceiver = comm.SDRuReceiver( ...
    'Platform', deviceNameSDR, ...
    'SerialNum', '31216FC');
% sdrReceiver.BasebandSampleRate = sdrTransmitter.BasebandSampleRate;
% %FIXME sdruReceiver doesnt have this field
sdrReceiver.CenterFrequency = sdrTransmitter.CenterFrequency;
sdrReceiver.OutputDataType = 'double';
sdrReceiver.ChannelMapping = 1; % Configure Rx channel map
% sdrReceiver.ShowAdvancedProperties = true; % FIXME Unrecognized property
% 'ShowAdvancedProperties' for class 'comm.SDRuTransmitter'
% sdrReceiver.BypassUserLogic = true; % FIXME same thing

% Configure receive samples equivalent to twice the length of the
% transmitted signal, this is to ensure that PSDUs are received in order.
% On reception the duplicate MAC fragments are removed.
samplesPerFrame = int16(2^15); % length(txWaveform); % FIXME I hardcoded this 
requiredCaptureLength = samplesPerFrame*2;
% spectrumScope.SampleRate = sdrReceiver.BasebandSampleRate; % FIXME
% samplerate DNE for this object

% Get the required field indices within a PSDU
indLSTF = wlanFieldIndices(nonHTcfg,'L-STF');
indLLTF = wlanFieldIndices(nonHTcfg,'L-LTF');
indLSIG = wlanFieldIndices(nonHTcfg,'L-SIG');
Ns = indLSIG(2)-indLSIG(1)+1; % Number of samples in an OFDM symbol