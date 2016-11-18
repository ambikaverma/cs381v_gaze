WIDTH = 200 + randi(500);
HEIGHT = 200 + randi(500);
NUM_CELLS = 20 + randi(5);

% Dimensions of each individual cell.
cell_width = ceil(WIDTH / NUM_CELLS);
cell_height = ceil(HEIGHT / NUM_CELLS);

% Set up plotting.
clf;
axis ij;
axis([1, WIDTH, 1, HEIGHT]);

% Plot the cell boundaries.
for i = 1:NUM_CELLS
    line([1, WIDTH], [cell_height * i, cell_height * i]);
    line([cell_width * i, cell_width * i], [1, HEIGHT]);
end

% Label every cell.
hold on;
counter = 1;
for i = 1:NUM_CELLS
    for j = 1:NUM_CELLS
        [x, y] = class_to_xy(counter, WIDTH, HEIGHT, NUM_CELLS);
        plot(x, y, '*');
        text(x, y, sprintf('%d', counter), 'Units', 'data');
        counter = counter + 1;
    end
end
hold off;

% Click in a cell and hope the decoder works.
for i = 1:10
    fprintf('You clicked in cell %d\n', ...
            xy_to_class(ginput(1), WIDTH, HEIGHT, NUM_CELLS));
end
