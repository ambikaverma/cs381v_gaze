% This file gathers data for the images with multiple gazes.
%
% The fields present are -
% (str) image path
% (xy array) pairs of eyes
% (xy array) pairs of gazes

% Utility functions.
addpath('/Users/bradyzhou/code/cs381v_final/lib');

% Path to train annotations.
TRAIN = '/Users/bradyzhou/code/cs381v_final/data/gazefollow/train_annotations.mat'

% Path to predicted gazes.
PREDICTIONS = '/Users/bradyzhou/code/cs381v_final/data/train_gazes.txt';

data = load(TRAIN);
multiple_gazes_path = get_duplicates(data.train_path);
num_rows = size(data.train_eyes, 2);
num_multiple = size(multiple_gazes_path, 2);

% Map of structs to populate.
gaze_info = containers.Map;

% Initialize the map.
for i = 1:size(multiple_gazes_path, 1)
    path = multiple_gazes_path(i, :);
    gaze_info(path) = struct('path', path, ...
                             'eyes', [], ...
                             'predictions', [], ...
                             'gazes', []);
end

% Go through all data.
for i = 1:num_rows
    path = data.train_path{i};
    if ~gaze_info.isKey(path)
        continue
    end

    % Add the extra data in.
    info = gaze_info(path);
    info.eyes = [info.eyes; cell2mat(data.train_eyes(i))];
    info.gazes = [info.gazes; cell2mat(data.train_gaze(i))];
    gaze_info(path) = info;
end

% Get the CNN predictions.
[filename, ~, ~, predict_x, predict_y] = textread(PREDICTIONS, '%s %f %f %f %f\n');
predictions = [filename num2cell(predict_x) num2cell(predict_y)];

for i = 1:size(predictions, 1)
    path = predictions{i, 1};
    if ~gaze_info.isKey(path)
        continue
    end

    % Add the extra data in.
    info = gaze_info(path);
    info.predictions = [info.predictions; ...
                        cell2mat(predictions(i, 2:3))];
    gaze_info(path) = info;
end

% Turn the map into an array.
gaze_info_keys = gaze_info.keys;
gaze_info_array = repmat(struct('path', '', ...
                                'eyes', [], ...
                                'predictions', [], ...
                                'gazes', []), ...
                         num_multiple, 1);
for i = 1:size(gaze_info_keys, 2)
    path_cell = gaze_info_keys(i);
    path = path_cell{1};
    gaze_info_array(i) = gaze_info(path);
end
