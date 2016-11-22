% Returns the final optimized parameters, l2 error, and angular error.
% IMPORTANT: assumes paths have been set up.
%
% Args:
%   batch_size - (int) number of samples to consider for a run.
%   epochs - (int) number of times to run.
%   root_image_path - (str) path to root directory of images.
%   data - (struct) array of all training data.
% Returns:
%   params - (4x1 of double), the sigma, c_2, c_3, c_b used in the model.

function [params] = train(batch_size, epochs, root_image_path, data)
    % Model parameters, see mrf.m for details.
    NUM_CELLS = 20;

    % Initialize info.
    multiple_gaze_data = data.gaze_info_array;
    indices = randperm(size(multiple_gaze_data, 1));

    % Training model.
    min_angular_error = Inf;
    min_l2_error = Inf;

    for epoch = 1:epochs
        SIGMA = rand() * 5;
        C_2 = rand() * 0.1;
        C_3 = rand() * 5;
        C_B = 0.5 + rand() / 2;

        % Error accumulators.
        total_angular_error = 0;
        total_l2_error = 0;
        total = 0;
        failed = 0;
        indices = randperm(size(multiple_gaze_data, 1));

        for i = 1:batch_size
            % Extract from array.
            gaze_data = multiple_gaze_data(indices(i));
            image_path = fullfile(root_image_path, gaze_data.path);
            eyes = gaze_data.eyes;
            cnn_predictions = gaze_data.predictions;
            gazes = gaze_data.gazes;

            % Extra information.
            im = imread(image_path);
            num_subjects = size(eyes, 1);

            % Jiggled eye position and gaze vectors.
            [faces, orientations] = get_face_orientation(eyes, gazes);

            try
                % Calculate maximum joint probability.
                predictions = mrf(im, faces, orientations, cnn_predictions, ...
                                  NUM_CELLS, num_subjects, ...
                                  SIGMA, C_2, C_3, C_B, 0);

                % Calculate average difference in angles.
                angular_error = calculate_average_angular_error(faces, predictions, ...
                                                                eyes, gazes);
                total_angular_error = total_angular_error + angular_error;

                % Calculate average normalized euclidean distance.
                l2_error = calculate_average_l2_error(predictions, gazes);
                total_l2_error = total_l2_error + l2_error;

                % Number of successful runs.
                total = total + 1;
            catch ME
                failed = failed + 1;
            end
        end

        % Too many failures, ignore this run.
        if failed > total
            continue;
        end

        batch_angular_error = total_angular_error / total;
        batch_l2_error = total_l2_error / total;

        if batch_l2_error < min_l2_error
            min_angular_error = batch_angular_error
            min_l2_error = batch_l2_error

            fprintf('SIGMA = %f;\n', SIGMA);
            fprintf('C_2 = %f;\n', C_2);
            fprintf('C_3 = %f;\n', C_3);
            fprintf('C_B = %f;\n', C_B);

            params = [SIGMA; C_2; C_3; C_B];
        end
    end
end
