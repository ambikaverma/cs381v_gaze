%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Path setup.                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[source_dir, ~, ~] = fileparts(mfilename('fullpath'));
[main_dir, ~, ~] = fileparts(source_dir);

% Included source code.
LIB_PATH = fullfile(main_dir, './lib');
GCMEX_PATH = fullfile(main_dir, './third_party/GCMEX');
% Path to gazefollow dataset.
IMAGE_PATH = fullfile(main_dir, './data/gazefollow');
% Path to mat file with multiple gaze data.
GAZE_MAT = fullfile(main_dir, './data/multiple_gaze_train.mat');

% Add paths.
addpath(LIB_PATH);
addpath(GCMEX_PATH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Experiment parameters.
BATCH_SIZE = 50;
EPOCHS = 20;
STEP = 5;

% Initialize info.
data = load(GAZE_MAT);
multiple_gaze_data = data.gaze_info_array;

for i = 1:10
    [model, metrics] = train(i * STEP, BATCH_SIZE, EPOCHS, IMAGE_PATH, ...
                             multiple_gaze_data);
    training_models(i, :) = model'
    training_metrics(i, :) = metrics'
end
