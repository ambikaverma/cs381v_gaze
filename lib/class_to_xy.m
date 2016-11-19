% Decoder for class label to centered x, y of cell.
%
% For example:
% class = 8
% width, height = (30, 30)
% num_cells = 3
% this would return (16, 26) since the grid is constructed as follows -
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
%   class - (int) class label to decode..
%   width - (int) width of the image.
%   height - (int) height of the image.
%   num_cells - (int) amount the image was discretized into.
% Returns:
%   [x_coord, y_coord] (1x2) image coordinates.

function [x_coord, y_coord] = class_to_xy(class, width, height, num_cells)
    x = mod(class - 1, num_cells);
    y = floor((class - x + 1) / num_cells);

    cell_width = ceil(width / num_cells);
    cell_height = ceil(height / num_cells);

    % Discretized grid positions.
    x_coord = cell_width / 2 + x * cell_width;
    y_coord = cell_height / 2 + y * cell_height;
end
