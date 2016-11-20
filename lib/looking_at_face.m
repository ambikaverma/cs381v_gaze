% This function returns true if the gaze is at another face.
%
% Args:
% look - (1x2) discretized place the person is looking at.
% faces - (nx2) discretized positions of other faces.

function is_looking_at_face = looking_at_face(look, faces)
    % Number of cells away.
    THRESHOLD = 1;

    % Iterate through faces and check distance.
    is_looking_at_face = false;
    for i = 1:size(faces, 1)
        if norm(look - faces(i, :)) <= THRESHOLD
            is_looking_at_face = true;
        end
    end
end
