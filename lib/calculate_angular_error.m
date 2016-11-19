% Used for testing accuracy.
%
% Args:
%   head1 - (x, y), a point
%   gaze1 - (x, y), a point
%   head2 - (x, y), a point
%   gaze2 - (x, y), a point
% Returns:
%   result (float) angular error between the two

function result = calculate_angular_error(head1, gaze1, head2, gaze2)
    u = gaze1 - head1;
    v = gaze2 - head2;
    u = u / norm(u);
    v = v / norm(v);
    result = acosd(dot(u, v));
end
