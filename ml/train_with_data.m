% script should be run from ml directory
curr_d = cd;
parent = fullfile(curr_d, "..");
cd(parent)
cd data
labels = zeros(0);
captures = zeros(200, 52, 0);
num_captures = 0;
% iterate through files in data directory
files = dir("*.mat");
for file_num = 1 : length(files)
    % filename is <date>_<h>_<m>_<s>_<gesture_name>_<distance>_<gesture_location>_csi_data.mat
    % data loaded into workspace as variable called training_csi
    filename = files(file_num).name;
    % get gesture label from filename
    split_filename = split(filename, ["_", "."]);
    gesture_name = split_filename(5);
    if strcmp(gesture_name, "nothing")
        label = 1;
    elseif strcmp(gesture_name, "hand")
        label = 2;
    end
    % 200 x 52 x N samples, N captures
    load(filename);
    % iterate over captures in this file
    for capture_num = 1 : size(training_csi, 3)
        capture = training_csi(:, :, capture_num);
        % ignore captures that are 0, these packets were undecodable
        if all(capture, 'all')
            captures(:, :, num_captures+1) = capture;
            num_captures = num_captures + 1;
            labels(num_captures) = label;
        end
    end
end
cd(parent)
cd ml
% train CNN
[info, perf, net] = wave_cnn(captures, labels', 2);
filename = strcat(regexprep(datestr(datetime), '(\s|:)+', '_'), ...
    "_", "wave_model");
save (filename, "net")