% Utility functions.
addpath('/Users/bradyzhou/code/cs381v_final/lib');

% Path to gazefollow dataset.
IMAGE_PATH = '/Users/bradyzhou/code/cs381v_final/data/gazefollow/'

% Path to mat file with multiple gaze data.
GAZE_MAT = '/Users/bradyzhou/code/cs381v_final/data/multiple_gaze_data.mat'

% Model parameters, see mrf.m for details.
SIGMA = 0.5;
C_2 = 1;
C_3 = 2;
C_B = 0.5;

% Initialize info.
data = load(GAZE_MAT);
multiple_gaze_data = data.gaze_info_array;
num_gaze_data = size(multiple_gaze_data, 1);

for i = 1:num_gaze_data
    % Extract from array.
    gaze_data = multiple_gaze_data(i);
    image_path = strcat(IMAGE_PATH, gaze_data.path);
    eyes = gaze_data.eyes;
    predictions = gaze_data.predictions;
    gazes = gaze_data.gazes;

    % Extra information.
    im = imread(image_path);
    num_subjects = size(eyes, 1);

    % Jiggled eye position and gaze vectors.
    [faces, orientations] = get_face_orientation(eyes, gazes);

    % Used for debugging.
    clf;
    image(im);
    hold on;
    plot_image_eye_gaze(im, eyes, gazes, 'r');
    plot_image_eye_gaze(im, eyes, predictions, 'c');
    plot_image_face_orientation(im, faces, orientations);

    % Calculate maximum joint probability.
    mrf_predictions = mrf(im, faces, orientations, predictions, 5, num_subjects, ...
                          SIGMA, C_2, C_3, C_B);
    plot_image_eye_gaze(im, eyes, mrf_predictions, 'g');
    hold off;
    pause;
end
