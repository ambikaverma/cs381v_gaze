% Utility functions.
addpath('/Users/bradyzhou/code/cs381v_final/lib');
addpath('/Users/bradyzhou/code/cs381v_final/src');

% Path to gazefollow dataset.
IMAGE_PATH = '/Users/bradyzhou/code/cs381v_final/data/gazefollow/'

% Path to mat file with multiple gaze data.
GAZE_MAT = '/Users/bradyzhou/code/cs381v_final/data/multiple_gaze_data.mat'

% Initialize info.
data = load(GAZE_MAT);
multiple_gaze_data = data.multiple_gaze_info;
num_gaze_data = size(multiple_gaze_data, 1);

for i = 1:num_gaze_data
    % Extract from array.
    gaze_data = multiple_gaze_data(i);
    image_path = strcat(IMAGE_PATH, gaze_data.path);
    eyes = gaze_data.eyes;
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
    plot_image_eye_gaze(im, eyes, gazes);
    plot_image_face_orientation(im, faces, orientations);
    hold off;
    pause;
end
