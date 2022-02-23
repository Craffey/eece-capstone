curr_d = cd;
parent = fullfile(curr_d, "..");
cd parent
labels = zeros(0);
captures = zeros(200, 52, 0);
num_captures = 0;
% iterate through files in data directory
files = dir("*.mat");
for file_num = 1 : length(files)
    % filename is <gesture_name>_<distance>_<gesture_location>_csi_data.mat
    % data loaded into workspace as variable called training_csi
    filename = files(file_num);
    % get gesture label from filename
    split_filename = split(filename, [",", "."]);
    gesture_name = split_filename(0);
    if strcmp(gesture_name, "nothing")
        label = 0;
    elseif strcmp(gesture_name, "something")
        label = 1;
    end
    % 200 x 52 x N samples, N captures
    load(filename);
    % iterate over captures in this file
    for capture_num = 1 : size(training_csi, 3)
        capture = training_csi(:, :, capture_num);
        captures(:, :, num_captures+1) = capture;
        num_captures = num_captures + 1;
        labels(num_captures) = label;
    end
end