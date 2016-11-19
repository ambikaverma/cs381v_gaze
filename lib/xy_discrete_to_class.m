% Turns a cell x y into the class label.
%
% Args:
% x - (int) x position to decode.
% y - (int) y position to decode.
% num_cells - (int) amount the image was discretized into.

function class = xy_discrete_to_class(x, y, num_cells)
    % 1 indexed.
    class = 1 + y * num_cells + x;
end
