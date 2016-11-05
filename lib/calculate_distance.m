function result = calculate_distance(gaze1, gaze2)
% Params:
%   gaze1: (x, y), a point
%   gaze2: (x, y), a point
% Returns:
%   result: float, distance between the two

result = norm(gaze1 - gaze2)
