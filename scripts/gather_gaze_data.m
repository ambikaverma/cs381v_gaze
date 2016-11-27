% This file gathers data for the images with multiple gazes.
%
% The fields present are -
% (str) image path
% (xy array) pairs of eyes
% (xy array) pairs of gazes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Path setup.                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[source_dir, ~, ~] = fileparts(mfilename('fullpath'));
[main_dir, ~, ~] = fileparts(source_dir);

% Included source code.
LIB_PATH = fullfile(main_dir, './lib');

% Path to train annotations.
TRAIN = fullfile(main_dir, './data/gazefollow/train_annotations.mat');

% Path to predicted gazes.
PREDICTIONS = fullfile(main_dir, './data/train_gazes.txt');

% Add paths.
addpath(LIB_PATH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = load(TRAIN);
multiple_gazes_path = get_duplicates(data.train_path);
num_rows = size(data.train_eyes, 2);
num_multiple = size(multiple_gazes_path, 2);

% Map of structs to populate.
gaze_info = containers.Map;

% Initialize the map.
for i = 1:size(multiple_gazes_path, 1)
    image_path = multiple_gazes_path(i, :);
    gaze_info(image_path) = struct('image_path', image_path, ...
                                   'eyes', [], ...
                                   'predictions', [], ...
                                   'gazes', []);
end

% Go through all data.
for i = 1:num_rows
    image_path = data.train_path{i};

    % Ignore if the image does not contain multiple people.
    if ~gaze_info.isKey(image_path)
        continue
    end

    % Add the extra data in.
    info = gaze_info(image_path);
    info.eyes = [info.eyes; cell2mat(data.train_eyes(i))];
    info.gazes = [info.gazes; cell2mat(data.train_gaze(i))];
    % Temporarily will be eyes to populate corresponding cnn predictions later.
    info.predictions = info.eyes;
    gaze_info(image_path) = info;
end

% Get the CNN predictions.
[filename, eye_x, eye_y, predict_x, predict_y] = textread(PREDICTIONS, ...
                                                          '%s %f %f %f %f\n');
predictions = [filename ...
               num2cell(eye_x) num2cell(eye_y) ...
               num2cell(predict_x) num2cell(predict_y)];

for i = 1:size(predictions, 1)
    image_path = predictions{i, 1};

    % Ignore if the image does not contain multiple people.
    if ~gaze_info.isKey(image_path)
        continue
    end

    eyes = cell2mat(predictions(i, 2:3));
    cnn_prediction = cell2mat(predictions(i, 4:5));

    % Add the extra data in.
    info = gaze_info(image_path);

    % Find the eye that corresponds with the guess.
    for j = 1:size(info.eyes, 1)
        if norm(eyes - info.eyes(j, :)) < 1e-5
            info.predictions(j, :) = cnn_prediction;
        end
    end

    gaze_info(image_path) = info;
end

% Turn the map into an array.
gaze_info_keys = gaze_info.keys;
gaze_info_array = repmat(struct('image_path', '', ...
                                'eyes', [], ...
                                'predictions', [], ...
                                'gazes', []), ...
                         num_multiple, 1);
for i = 1:size(gaze_info_keys, 2)
    image_path_cell = gaze_info_keys(i);
    image_path = image_path_cell{1};
    gaze_info_array(i) = gaze_info(image_path);
end
