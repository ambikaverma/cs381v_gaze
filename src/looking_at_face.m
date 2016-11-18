% Utility functions.
addpath('/Users/bradyzhou/code/cs381v_final/lib');

% This function returns true if the gaze is at another face.
%
% Args:
% look - (1x2) discretized place the person is looking at.
% faces - (nx2) discretized positions of other faces.

function is_looking_at_face = looking_at_face(look, faces)
    is_looking_at_face = ismember(look, faces, 'rows');
end
