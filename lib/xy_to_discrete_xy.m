% Encoder for x, y to class label.
%
% For example:
% x, y = (20, 30)
% width, height = (30, 30)
% num_cells = 3
% this would return 8 since the grid is constructed as follows -
%    1  11  21  31 X
%  1 -------------
%    | 1 | 2 | 3 |
% 11 -------------
%    | 4 | 5 | 6 |
% 21 -------------
%    | 7 | 8 | 9 |
% 31 -------------
%  Y
%
% Args:
%   position - (1x2) xy position to decode.
%   width - (int) width of the image.
%   height - (int) height of the image.
%   num_cells - (int) amount the image was discretized into.
% Returns:
%   [x, y] (1x2) int of cell position.

function [x, y] = xy_to_discrete_xy(position, width, height, num_cells)
    cell_width = ceil(width / num_cells);
    cell_height = ceil(height / num_cells);

    % Discretized grid positions.
    x = floor(position(1) / cell_width) + 1;
    y = floor(position(2) / cell_height) + 1;
end
