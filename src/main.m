% Utility functions.
addpath('/Users/bradyzhou/code/cs381v_final/lib');

% Path to gazefollow dataset.
IMAGE_PATH = '/Users/bradyzhou/code/cs381v_final/data/gazefollow/'

% Path to mat file with multiple gaze data.
GAZE_MAT = '/Users/bradyzhou/code/cs381v_final/data/multiple_gaze_data.mat'

% Enable plotting.
DEBUG = 0;

% Model parameters, see mrf.m for details.
NUM_CELLS = 10;
SIGMA = 0.5;
C_2 = 1;
C_3 = 10;
C_B = 5;

% Training details.
BATCH_SIZE = 100;

% Initialize info.
data = load(GAZE_MAT);
multiple_gaze_data = data.gaze_info_array;
indices = randperm(size(multiple_gaze_data, 1));

% Error accumulators.
total_angular_error = 0;
total = 0;

for i = 1:BATCH_SIZE
    % Extract from array.
    gaze_data = multiple_gaze_data(indices(i));
    image_path = strcat(IMAGE_PATH, gaze_data.path);
    eyes = gaze_data.eyes;
    cnn_predictions = gaze_data.predictions;
    gazes = gaze_data.gazes;

    % Extra information.
    im = imread(image_path);
    num_subjects = size(eyes, 1);

    % Jiggled eye position and gaze vectors.
    [faces, orientations] = get_face_orientation(eyes, gazes);

    % Calculate maximum joint probability.
    try
        predictions = mrf(im, faces, orientations, cnn_predictions, ...
                          NUM_CELLS, num_subjects, ...
                          SIGMA, C_2, C_3, C_B);
        angular_error = zeros(num_subjects, 1);
        for i = 1:num_subjects
            angular_error(i) = calculate_angular_error(eyes(i, :), ...
                                                       predictions(i, :), ...
                                                       eyes(i, :), ...
                                                       gazes(i, :));
        end

        tmp_angular_error = sum(angular_error) / size(angular_error, 1);

        total_angular_error = total_angular_error + tmp_angular_error;
        total = total + 1;
    catch
        fprintf('%s failed\n', image_path);
    end

    % Plotting stuff.
    if DEBUG == 1
        clf;
        image(im);
        hold on;
        plot_image_eye_gaze(im, eyes, gazes, 'r');
        plot_image_eye_gaze(im, eyes, cnn_predictions, 'c');
        plot_image_face_orientation(im, faces, orientations);
        plot_image_eye_gaze(im, eyes, predictions, 'g');
        hold off;
        pause;
    end

end

average_angular_error = total_angular_error / total
