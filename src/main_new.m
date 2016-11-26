%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Path setup.                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [source_dir, ~, ~] = fileparts(mfilename('fullpath'));
% [main_dir, ~, ~] = fileparts(source_dir);
clear all
close all
clc

% Included source code.
LIB_PATH = 'C:\Users\user1\Downloads\cs381v_gaze-master\lib\';
GCMEX_PATH = 'C:\Users\user1\Downloads\cs381v_gaze-master\third_party\GCMex';
% Path to gazefollow dataset.
IMAGE_PATH = 'C:\Users\user1\Downloads\381v_project_data';
% Path to mat file with multiple gaze data.
GAZE_MAT =  'C:\Users\user1\Downloads\cs381v_gaze-master\data\multiple_gaze_data.mat';
SRC_PATH='C:\Users\user1\Downloads\cs381v_gaze-master\src';

% Add paths.
addpath(LIB_PATH);
addpath(GCMEX_PATH);
addpath(SRC_PATH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enable plotting.
DEBUG = 0;

% Experiment parameters.
BATCH_SIZE = 1000;

% Model parameters, see mrf.m for details.
NUM_CELLS = 20;
SIGMA = 3.407696;
C_2 = 0.083733;
C_3 = 0.910963;
C_B = 0.636215;

% Initialize info.
data = load(GAZE_MAT);
[data2,path2]=xlsread('train_gaze.xlsx');
load('train_annotations.mat');
n = size(data.gaze_info_array, 1);

% Initialize info.
multiple_gaze_data = data.gaze_info_array;
indices = randperm(size(multiple_gaze_data, 1));
indices = [1:n];

% Error accumulators.
total_angular_error = 0;
total_l2_error = 0;
total = 0;
u=1;
for i = 1:BATCH_SIZE
    % Extract from array.
    gaze_data = multiple_gaze_data(indices(i));
    image_path = fullfile(IMAGE_PATH, gaze_data.path);
    index=find(strcmp(path2,gaze_data.path));
    index2=find(strcmp(train_path,gaze_data.path));
    s=size(index2,1);
    
        eyes=reshape(cell2mat(train_eyes(index2)),2,s)';
        cnn_predictions=data2(index,3:4);
        if isempty(cnn_predictions)==1
            continue;
        end
        gazes=reshape(cell2mat(train_gaze(index2)),2,s)';
    
%     eyes = gaze_data.eyes;
%     cnn_predictions = gaze_data.predictions;
%     gazes = gaze_data.gazes;

    % Extra information.
    im = imread(image_path);
    num_subjects = size(eyes, 1);

    % Jiggled eye position and gaze vectors.
    [faces, orientations] = get_face_orientation(eyes, cnn_predictions);

    % Plotting stuff.
    if DEBUG == 1
        clf;
        image(im);
        hold on;
        plot_image_eye_gaze(im, eyes, gazes, 'r');
        plot_image_eye_gaze(im, eyes, cnn_predictions, 'c');
        plot_image_face_orientation(im, faces, orientations);
    end

%     try
        % Calculate maximum joint probability.
        predictions = mrf(im, faces, orientations, cnn_predictions, ...
                          NUM_CELLS, num_subjects, ...
                          SIGMA, C_2, C_3, C_B);

        % Calculate average angular error.
%         angular_error = calculate_average_angular_error(faces, predictions, ...
%                                                         eyes, gazes);
%         total_angular_error = total_angular_error + angular_error;
% 
% %         Calculate average normalized euclidean distance.
%         l2_error = calculate_average_l2_error(predictions, gazes);
%         total_l2_error = total_l2_error + l2_error;

%         total = total + 1;
m=size(eyes,1);
for j=1:m
    l2_distance(u)=calculate_distance(gazes(m,:),predictions(m,:));
    u=u+1;
end

        % Plotting stuff.
        if DEBUG == 1
            plot_image_eye_gaze(im, faces, predictions, 'g');
            hold off;
            pause;
        end
%     catch ME
%         fprintf('Image %s failed.\n', image_path);
%     end
 end
sum(l2_distance)/nnz(l2_distance)
% total_angular_error / total
% total_l2_error / total
