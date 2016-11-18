% This function returns the Gaussian perturbed eye positions and gazes.
% Used to fake face and orientation in the lack of a decent head detector.
%
% Args:
% eyes - (nx2) x,y pairs of eyes
% gazes - (nx2) x,y pairs of gazes

function [faces, orientations] = get_face_orientation(eyes, gazes)
    SIGMA_FACE = 0.01;
    SIGMA_ORIENTATION = 0.1;
    n = size(eyes, 1);

    % True gaze orientations, to be jiggled later.
    orientations = gazes - eyes;

    % Jiggle the positions
    faces = SIGMA_FACE * randn(n, 2) + eyes;

    % Orientations are unit vectors.
    orientations = SIGMA_ORIENTATION * randn(n, 2) + orientations;
    for i = 1:n
        orientations(i, :) = orientations(i, :) / norm(orientations(i, :));
    end
end
