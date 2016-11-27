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

% Timing stuff.
start_time = cputime();

% Do some functional programming stuff.
trainer = @(x) train(x, BATCH_SIZE, EPOCHS, IMAGE_PATH, multiple_gaze_data);
[models, metrics] = arrayfun(@(x) trainer(x), [5:10].*STEP, ...
                             'UniformOutput', false);

% Results.
end_time = cputime();
fprintf('Elapsed training time: %fs\n', end_time - start_time);

cell2mat(models)
cell2mat(metrics)
