% Encoder for x, y to class label.
%
% For example:
% x, y = (20, 30)
% width, height = (30, 30)
% num_cells = 3
% this would return 8 since the grid is constructed as follows -
%  Y
% 31 -------------
%    | 7 | 8 | 9 |
% 21 -------------
%    | 4 | 5 | 6 |
% 11 -------------
%    | 1 | 2 | 3 |
%  1 -------------
%    1  11  21  31 X
%
% Args:
% position - (1x2) xy position to decode.
% width - (int) width of the image.
% height - (int) height of the image.
% num_cells - (int) amount the image was discretized into.

function class = xy_to_class(position, width, height, num_cells)
    cell_width = round(width / num_cells);
    cell_height = round(height / num_cells);

    % Discretized grid positions.
    x = round(position(1) / cell_width);
    y = round(position(2) / cell_height);

    class = (y - 1) * num_cells + x;
end
