clear all
close all
% addpath(genpath('/data/vision/torralba/datasetbias/caffe-cudnn3/matlab/'));
load('C:\Users\user1\Downloads\381v_project_data\test_annotations.mat')
% [D,~,X] = unique(test_path(:));
% Y = hist(X,unique(X));
% Z = struct('name',D,'freq',num2cell(Y(:)));
% F={};
% count=0;
% for i=1:size(Z,1)
%     if Z(i).freq>1
%         temp=Z(i).name;
%         F=[F;temp];
%         count=count+1;
%     end
%     
% end
f=fopen('C:\Users\user1\Documents\MATLAB\test_project.txt','w');
for j=1:length(test_path)
%     im=imread(test_path{j});
    
    head_center=test_eyes{j};
%     [x_predict,y_predict,heatmap,net] = predict_gaze(im,e);
prediction=[0,1];
ground_truth=test_gaze{j};
ground_truth_gaze=mean(ground_truth,1);
%     prediction=[x_predict,y_predict];
    fprintf(f,'%d %s %4.2f %4.2f %4.2f %4.2f\r\n',j,test_path{j},ground_truth_gaze,prediction);
%     fprintf(f,'%4.2f \n',prediction);
end
fclose(f)
