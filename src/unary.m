% This function returns the unary potential of a single node.
%
% Args:
%   look - (1x2) place the person is looking at, this is the gaze to assess.
%   face - (1x2) position of the face/eye.
%   orientation - (1x2) unit vector of head orientation.
%   is_looking_at_face - (bool) if the label is on a face.
%   sigma - (float) model parameter, variance of gaze distribution.
%   c_2 - (float) model parameter, bias to push the gaze away its own face.
%   c_3 - (float) model parameter, bias to push look at other faces.
% Returns:
%   potential (float)

function potential = unary(look, face, orientation, is_looking_at_face, ...
                           sigma, c_2, c_3)
    % Gaussian distribution over all cells in the same direction.
    look_dir = (look - face) / norm(look - face);
    phi_1 = 1 / (sigma * sqrt(2 * pi)) * ...
            exp(-(norm(orientation - look_dir)) / (2 * sigma ^ 2));

    % Threshold to avoid a face from looking at itself.
    phi_2 = 1 / (1 + exp(-(c_2 * norm(look - face))));

    % Bias gazes towards looking at other faces.
    phi_3 = 0;
    if is_looking_at_face
        phi_3 = c_3;
    else
        phi_3 = 1;
    end

    % Unary potential is a product over phi_i.
    potential = phi_1 * phi_2 * phi_3;
end
