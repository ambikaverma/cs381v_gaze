% This function returns an array of xy pairs of gaze predictions.
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
% im - (image) the image to predict on.
% faces - (nx2) positions of all faces in the image.
% orientations - (nx2) unit vectors of all orientations.
% num_cells - (int) number of cells to discretize the image into.
% n - (int) number of faces in the image.
% sigma - (float) model parameter, variance of gaze distribution.
% c_2 - (float) model parameter, bias to push the gaze away its own face.
% c_3 - (float) model parameter, bias to push look at other faces.
% c_b - (float) model parameter, bias to push look at similar places.

function gazes = mrf(im, faces, orientations, num_cells, n, ...
                     sigma, c_2, c_3, c_b)
    % Setup.
    [h, w, ~] = size(im);
    c = num_cells^2;

    % Project faces back into image space.
    unnormalized_faces = zeros(n, 2);
    unnormalized_faces(:, 1) = w * faces(:, 1);
    unnormalized_faces(:, 2) = h * faces(:, 2);

    % Initialize energy functions.
    classes = zeros(1, n);
    unary_potentials = zeros(c, n);
    pairwise_potentials = zeros(c, c);

    % Populate unary potentials.
    for i = 1:c
        % The unary potential row denotes the label/location.
        [look_x, look_y] = class_to_xy(i, w, h, num_cells);

        % The unary potential column denotes the person number.
        for j = 1:n
            unary_potentials(i, j) = unary([look_x, look_y], ...
                                           unnormalized_faces(j, :), ...
                                           orientations(j, :), ...
                                           unnormalized_faces, ...
                                           sigma, c_2, c_3);
        end

        % Debug.
        text(look_x, look_y, sprintf('%.2f', unary_potentials(i, 1)), ...
             'Unit', 'Data', 'Color', 'r');
    end
    orientations
    keyboard;
end
