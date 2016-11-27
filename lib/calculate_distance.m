% Returns distance between two points.
%
% Args:
%   gaze1: (x, y), a point
%   gaze2: (x, y), a point
% Returns:
%   result: float, distance between the two

function result = calculate_distance(gaze1, gaze2)
    result = norm(gaze1 - gaze2);
end
