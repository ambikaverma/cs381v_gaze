DATA_PATH = '~/data/';
OUT_PATH = '~/train_gazes.txt';
ANNOTATIONS = 'train_annotations.mat';;
ANNOTATIONS_PATH = strcat(DATA_PATH, ANNOTATIONS);

% Caffe setup.
DEFINITION_FILE = ['deploy_demo.prototxt'];
BINARY_FILE = ['binary_w.caffemodel'];
caffe.set_mode_gpu();
caffe.set_device(0);
net = caffe.Net(DEFINITION_FILE, BINARY_FILE, 'train');

begin_time = cputime;
annotations = load(ANNOTATIONS_PATH);
number_samples = size(annotations.train_eyes, 2)

duplicated_gaze_paths = get_duplicates(annotations.train_path);

fileID = fopen(OUT_PATH, 'w');

for i=1:number_samples
    % if isempty(strmatch(annotations.train_path{i}, duplicated_gaze_paths))
    %     continue
    % end

    image_path = strcat(DATA_PATH, annotations.train_path{i});
    im = imread(image_path);

    % fprintf('%d\n', i);
    % e = annotations.train_eyes{i};

    try
        [x,y,heatmap,net] = predict_gaze(im, annotations.train_eyes{i}, net);

        %Visualization
        % g = floor([x_predict y_predict].*[size(im,2) size(im,1)]);
        % e = floor(e.*[size(im,2) size(im,1)]);

        fprintf(fileID, '%s ', annotations.train_path{i});
        fprintf(fileID, '%d %d %d %d\n', annotations.train_eyes{i}, x, y);
    catch
        fprintf('%d failed\n', i);
    end
end

fclose(fileID);

fprintf('Elapsed time: %f\n', cputime - begin_time);
