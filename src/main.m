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
DEBUG = 1;

% Model parameters, see mrf.m for details.
NUM_CELLS = 20;
SIGMA = 0.995778;
C_2 = 1.883166;
C_3 = 0.904200;
C_B = 0.949226;

% Initialize info.
data = load(GAZE_MAT);
n = size(data.gaze_info_array, 1);

% Extract from array.
gaze_data = multiple_gaze_data(indices(randi(n)));
image_path = fullfile(IMAGE_PATH, gaze_data.path);
eyes = gaze_data.eyes;
cnn_predictions = gaze_data.predictions;
gazes = gaze_data.gazes;

% Extra information.
im = imread(image_path);
num_subjects = size(eyes, 1);

% Jiggled eye position and gaze vectors.
[faces, orientations] = get_face_orientation(eyes, gazes);

% Plotting stuff.
if DEBUG == 1
    clf;
    image(im);
    hold on;
    plot_image_eye_gaze(im, eyes, gazes, 'r');
    plot_image_eye_gaze(im, eyes, cnn_predictions, 'c');
    plot_image_face_orientation(im, faces, orientations);
end

% Calculate maximum joint probability.
predictions = mrf(im, faces, orientations, cnn_predictions, ...
                  NUM_CELLS, num_subjects, ...
                  SIGMA, C_2, C_3, C_B);

% Calculate average angular error.
angular_error = calculate_average_angular_error(eyes, predictions, eyes, gazes)

% Calculate average normalized euclidean distance.
l2_error = calculate_average_l2_error(predictions, gazes)

% Plotting stuff.
if DEBUG == 1
    plot_image_eye_gaze(im, eyes, predictions, 'g');
    hold off;
end
