%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Path setup.                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[source_dir, ~, ~] = fileparts(mfilename('fullpath'));
[main_dir, ~, ~] = fileparts(source_dir);

% Included source code.
LIB_PATH = fullfile(main_dir, './lib');
GCMEX_PATH = fullfile(main_dir, './third_party/GCMEX');
% Path to gazefollow dataset.
IMAGE_PATH = fullfile(main_dir, './data/gazefollow');
% Path to mat file with multiple gaze data.
GAZE_MAT = fullfile(main_dir, './data/multiple_gaze_data.mat');

% Add paths.
addpath(LIB_PATH);
addpath(GCMEX_PATH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enable plotting.
DEBUG = 0;

% Experiment parameters.
BATCH_SIZE = 1000;

% Initialize info.
data = load(GAZE_MAT);
n = size(data.gaze_info_array, 1);

% Initialize info.
multiple_gaze_data = data.gaze_info_array;
indices = randperm(size(multiple_gaze_data, 1));

% Error accumulators.
total_angular_error = 0;
total_l2_error = 0;
total = 0;

for i = 1:BATCH_SIZE
    % Extract from array.
    gaze_data = multiple_gaze_data(indices(i));
    image_path = fullfile(IMAGE_PATH, gaze_data.path);
    eyes = gaze_data.eyes;
    cnn_predictions = gaze_data.predictions;
    gazes = gaze_data.gazes;

    % Plotting stuff.
    if DEBUG == 1
        im = imread(image_path);
        clf;
        image(im);
        hold on;
        plot_image_eye_gaze(im, eyes, gazes, 'r');
        plot_image_eye_gaze(im, eyes, cnn_predictions, 'c');
        hold off;
        pause;
    end

    try
        % Calculate average difference in angles.
        angular_error = calculate_average_angular_error(eyes, cnn_predictions, ...
                                                        eyes, gazes);
        total_angular_error = total_angular_error + angular_error;

        % Calculate average normalized euclidean distance.
        l2_error = calculate_average_l2_error(cnn_predictions, gazes);
        total_l2_error = total_l2_error + l2_error;

        % Number of successful runs.
        total = total + 1;
    catch ME
        fprintf('Image %s failed.\n', image_path);
    end
end

total_angular_error / total
total_l2_error / total
