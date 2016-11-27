% This function returns an array of xy pairs of gaze predictions.
% IMPORTANT: assumes GCMex, lib has been imported already.
%
% The expanded distribution looks like the following -
% ---------------------------------------------------------------
% |f_1|f_2|...|f_n|np_1|np_2|...|np_n|ep_1|ep_1|...|ep_n^2|pot|p|
% ---------------------------------------------------------------
%
% Which has the following properties -
% f_i, a face looking at a particular location l_i (i, j).
% np_1, the unary potential phi_u(f_i = l_i).
% ep_1, the pairwise potential phi_u(f_i = l_i, f_j = l_j).
% pot, the product of all potentials.
% p, the normalize potential, pot / sum(pot).
%
% Args:
%   im - (image) the image to predict on.
%   faces - (nx2) positions of all faces in the image.
%   orientations - (nx2) unit vectors of all orientations.
%   predictions - (nx2) initial seeds for alpha expansion.
%   num_cells - (int) number of cells to discretize the image into.
%   n - (int) number of faces in the image.
%   sigma - (float) model parameter, variance of gaze distribution.
%   c_2 - (float) model parameter, bias to push the gaze away its own face.
%   c_3 - (float) model parameter, bias to push look at other faces.
%   c_b - (float) model parameter, bias to push look at similar places.
%   debug - (bool) debug mode.
% Returns:
%   gazes (nx2) refined gaze predictions in normalized coordinates [0, 1].
% Throws:
%   MException if the energy after is NaN (faulty inputs?).

function gazes = mrf(im, faces, orientations, predictions, ...
                     num_cells, n, ...
                     sigma, c_2, c_3, c_b, debug)
    % Setup.
    [h, w, ~] = size(im);
    c = num_cells^2;

    % Project faces back into image space.
    unnormalized_faces = zeros(n, 2);
    unnormalized_faces(:, 1) = w * faces(:, 1);
    unnormalized_faces(:, 2) = h * faces(:, 2);

    % Discrete faces.
    discrete_faces = zeros(n, 2);
    for i = 1:n
        [x, y] = xy_to_discrete_xy(unnormalized_faces(i, 1:2), w, h, num_cells);
        discrete_faces(i, :) = [x, y];
    end

    % Project gaze predictions back into image space.
    unnormalized_predictions = zeros(n, 2);
    unnormalized_predictions(:, 1) = w * predictions(:, 1);
    unnormalized_predictions(:, 2) = h * predictions(:, 2);

    % Initialize energy functions.
    classes = ones(1, n);
    unary_pot = zeros(c, n);
    pairwise_pot = sparse(n, n);
    labelcost = zeros(c);

    % Populate initial guesses.
    for i = 1:n
        % Initialized guesses from CNN.
        classes(i) = xy_to_class(unnormalized_predictions(i, :), w, h, num_cells);

        % IMPORTANT: comment out to test different seeds.
        % Random intialized guesses.
        % classes(i) = randi(c);
    end

    % Populate unary potentials.
    for i = 1:c
        % The unary potential row denotes the label/location.
        [look_x, look_y] = class_to_xy(i, w, h, num_cells);
        [cell_x, cell_y] = xy_to_discrete_xy([look_x, look_y], w, h, num_cells);

        % Contains a face.
        is_looking_at_face = looking_at_face([cell_x, cell_y], discrete_faces);

        % The unary potential column denotes the person number.
        for j = 1:n
            % Clamp to the image dimensinos.
            if look_x <= w && look_y <= h
                unary_pot(i, j) = -unary([look_x, look_y], ...
                                         unnormalized_faces(j, :), ...
                                         orientations(j, :), ...
                                         is_looking_at_face, ...
                                         sigma, c_2, c_3);
            else
                unary_pot(i, j) = 1e10;
            end

            % IMPORTANT: comment out to test different seeds.
            % Initialize classes to optimized unaries.
            % if unary_pot(i, j) < unary_pot(classes(j), j)
            %     classes(j) = i;
            % end
        end

        % Prints the unary potentials of a single label on all cells.
        if debug == 1
            text(look_x, look_y, sprintf('%.2f', unary_pot(i, 1)), ...
                 'Unit', 'Data', 'Color', 'r');

            % Print cell label.
            % text(look_x, look_y, sprintf('%d', i), 'Color', 'g');
        end
    end

    % The potentials are shown for this face.
    if debug == 1
        plot(unnormalized_faces(1, 1), unnormalized_faces(1, 2), ...
             'w.', 'Markersize', 30);
    end

    % Populate pairwise label costs.
    for i = 1:n
        for j = 1:n
            if i == j
                pairwise_pot(i, j) = -c_b;
            else
                pairwise_pot(i, j) = -(1 - c_b);
            end
        end
    end

    % The following cases cause seg faults in GCMex.
    if c_b == 1
        ex = MException('MRF:Error', ...
                        'c_b must be a value in the range [0.5, 1)].');
        throw(ex);
    else if any(isnan(unary_pot))
        ex = MException('MRF:Error', ...
                        'Unary potential was NaN. Check parameters.');
        throw(ex);
    end

    % Solve for minimizing energy.
    [labels, energy, energyafter] = GCMex(classes, single(unary_pot), ...
                                          pairwise_pot, single(labelcost), 1);

    if isnan(energyafter) || abs(energyafter) > 1e10
        ex = MException('GCMex:Error', 'NaN energy after solving.');
        throw(ex);
    elseif debug == 1
        fprintf('Energy solved. Before: %.3f, After: %.3f\n', energy, energyafter);
    end

    % Convert labels back into gazes.
    gazes = zeros(n, 2);
    for i = 1:n
        gaze_label = labels(i);
        if gaze_label == 0
            gaze_label = classes(i);
        end
        [predict_x, predict_y] = class_to_xy(gaze_label, w, h, num_cells);
        gazes(i, 1) = predict_x / w;
        gazes(i, 2) = predict_y / h;
    end
end
