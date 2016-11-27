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
GAZE_MAT = fullfile(main_dir, './data/multiple_gaze_train.mat');

% Add paths.
addpath(LIB_PATH);
addpath(GCMEX_PATH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enable plotting.
DEBUG = 1;

% Experiment parameters.
BATCH_SIZE = 200;

% Model parameters, see mrf.m for details.
NUM_CELLS = 40;
SIGMA     = 1;
C_2       = 0.1;
C_3       = 1.5;
C_B       = 0.9;

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
    image_path = fullfile(IMAGE_PATH, gaze_data.image_path);

    eyes = gaze_data.eyes;
    cnn_predictions = gaze_data.predictions;
    gazes = gaze_data.gazes;

    % Extra information.
    im = imread(image_path);
    num_subjects = size(eyes, 1);

    % Jiggled eye position and gaze vectors.
    [faces, orientations] = get_face_orientation(eyes, cnn_predictions);

    % Plotting stuff.
    if DEBUG == 1
        clf;
        image(im);
        hold on;
        plot_image_eye_gaze(im, eyes, gazes, 'r');
        plot_image_eye_gaze(im, eyes, cnn_predictions, 'c');
        plot_image_face_orientation(im, faces, orientations);
    end

    try
        % Calculate maximum joint probability.
        predictions = mrf(im, faces, orientations, cnn_predictions, ...
                          NUM_CELLS, num_subjects, ...
                          SIGMA, C_2, C_3, C_B, DEBUG && 0);

        % Calculate average angular error.
        angular_error = calculate_average_angular_error(faces, predictions, ...
                                                        eyes, gazes);
        total_angular_error = total_angular_error + angular_error;

        % Calculate average normalized euclidean distance.
        l2_error = calculate_average_l2_error(predictions, gazes);
        total_l2_error = total_l2_error + l2_error;

        total = total + 1;

        % Plotting stuff.
        if DEBUG == 1
            plot_image_eye_gaze(im, faces, predictions, 'g');
            hold off;
            pause;
        end
    catch ME
        fprintf('Image %s failed.\n', image_path);

        % Print exceptions.
        % fprintf('%s\n', getReport(ME));
    end
end

total_angular_error / total
total_l2_error / total
