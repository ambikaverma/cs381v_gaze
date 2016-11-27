% Returns the final optimized parameters, l2 error, and angular error.
% IMPORTANT: assumes paths have been set up.
%
% Args:
%   grid_size - (int) number of cells to discretize into.
%   batch_size - (int) number of samples to consider for a run.
%   epochs - (int) number of times to run.
%   root_image_path - (str) path to root directory of images.
%   multiple_gaze_data - (struct) array of all training data.
% Returns:
%   params - (4x1 of double), sigma, c_2, c_3, c_b used in the best model.
%   metrics - (2x1 of double), angular error and l2 error of the best model.

function [params, metrics] = train(grid_size, batch_size, epochs, ...
                                   root_image_path, multiple_gaze_data)
    % Percentage of failures allowed in a batch.
    FAILURE_TOLERANCE = 0.10;
    DEBUG = 0;

    % Training model.
    min_angular_error = Inf;
    min_l2_error = Inf;

    for epoch = 1:epochs
        % Model parameters.
        sigma = randrange(1, 5);
        c_2 = randrange(0, .25);
        c_3 = randrange(0, 5);
        c_b = randrange(0.5, 1);

        % Error accumulators.
        total_angular_error = 0;
        total_l2_error = 0;
        total = 0;
        failed = 0;
        indices = randperm(size(multiple_gaze_data, 1));

        for i = 1:min(batch_size, size(multiple_gaze_data, 1))
            if failed / batch_size > FAILURE_TOLERANCE
                break;
            end

            % Extract from array.
            gaze_data = multiple_gaze_data(indices(i));
            image_path = fullfile(root_image_path, gaze_data.image_path);
            eyes = gaze_data.eyes;
            cnn_predictions = gaze_data.predictions;
            gazes = gaze_data.gazes;

            % Extra information.
            im = imread(image_path);
            num_subjects = size(eyes, 1);

            try
                % Jiggled eye position and gaze vectors.
                [faces, orientations] = get_face_orientation(eyes, cnn_predictions);

                % Calculate maximum joint probability.
                predictions = mrf(im, faces, orientations, cnn_predictions, ...
                                  grid_size, num_subjects, ...
                                  sigma, c_2, c_3, c_b, 0);

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

                % Print exception.
                % fprintf('%s\n', getReport(ME));
            end
        end

        % Progress update.
        if DEBUG == 1
            fprintf('Training %5.2f%% completed.\n', epoch / epochs * 100);
        end

        % Too many failures, ignore this run.
        if failed / batch_size > FAILURE_TOLERANCE
            continue;
        end

        batch_angular_error = total_angular_error / total;
        batch_l2_error = total_l2_error / total;

        % if batch_l2_error < min_l2_error && batch_angular_error < min_angular_error
        if batch_l2_error < min_l2_error
            min_angular_error = batch_angular_error;
            min_l2_error = batch_l2_error;

            if DEBUG == 1
                fprintf('Angular error: %f;\n', min_angular_error);
                fprintf('L2 error: %f;\n', min_l2_error);
                fprintf('NUM_CELLS = %d;\n', grid_size);
                fprintf('SIGMA = %f;\n', sigma);
                fprintf('C_2 = %f;\n', c_2);
                fprintf('C_3 = %f;\n', c_3);
                fprintf('C_B = %f;\n', c_b);
            end

            params = [grid_size; sigma; c_2; c_3; c_b];
            metrics = [min_angular_error; min_l2_error];
        end
    end
end
