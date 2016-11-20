% This function returns the unary potential of a single node.
%
% Args:
% look - (1x2) place the person is looking at, this is the gaze to assess.
% face - (1x2) position of the face/eye.
% orientation - (1x2) unit vector of head orientation.
% faces - (nx2) positions of other faces.
% sigma - (float) model parameter, variance of gaze distribution.
% discrete_look - (1x2) cell position of label.
% discrete_faces - (nx2) cell positions of faces.
% sigma - (float) model parameter, variance of gaze distribution.
% c_2 - (float) model parameter, bias to push the gaze away its own face.
% c_3 - (float) model parameter, bias to push look at other faces.

function potential = unary(look, face, orientation, faces, ...
                           discrete_look, discrete_faces, ...
                           sigma, c_2, c_3)
    % Gaussian distribution over all cells.
    look_dir = (look - face) / norm(look - face);
    phi_1 = 1 / (sigma * sqrt(2 * pi)) * ...
            exp(-(norm(orientation - look_dir)) / (2 * sigma ^ 2));

    % Threshold to avoid a face from looking at itself.
    phi_2 = 1 / (1 + exp(-(c_2 * norm(look - face))));

    % Bias gazes towards looking at other faces.
    phi_3 = 0;
    if looking_at_face(discrete_look, discrete_faces)
        phi_3 = c_3;
    else
        phi_3 = 1;
    end

    % Unary potential is a product over phi_i.
    potential = phi_1 * phi_2 * phi_3;
end
