clear all
close all
clc
load('multiple_gaze_data (1).mat');
[data2,path2]=xlsread('train_gaze.xlsx');
load('train_annotations.mat');
% n=size(gaze_info_array,1);
% u=1;
% for i=1:n
%     im=imread(gaze_info_array(i).path);
%     eyes=gaze_info_array(i).eyes;
%     pred=gaze_info_array(i).predictions;
%     gt_gaze=gaze_info_array(i).gazes;
%     j=size(eyes,1);
%     for k=1:j
%         if isempty(pred)==1
%             continue;
%         end
%         l2_distance(u)=calculate_distance(gt_gaze(k,:),pred(k,:));
%         angular_error(u)=calculate_angular_error(eyes(k,:),gt_gaze(k,:),eyes(k,:),pred(k,:));
%         u=u+1;
%     end
% end
% sum(l2_distance)/nnz(l2_distance)
% check=isnan(angular_error);
% ii=find(check==1);
% angular_error(ii)=0;
% sum(angular_error)/nnz(angular_error)
n=size(gaze_info_array,1);
u=1;
for i=1:n
    index=find(strcmp(path2,gaze_info_array(i).path));
    index2=find(strcmp(train_path,gaze_info_array(i).path));
    s=size(index,1);
    for j=1:s
        eyes=cell2mat(train_eyes(index2(j)));
        pred=data2(index(j),3:4);
        if isempty(pred)==1
            continue;
        end
        gt_gaze=cell2mat(train_gaze(index2(j)));
        l2_distance(u)=calculate_distance(gt_gaze,pred);
        angular_error(u)=calculate_angular_error(eyes,gt_gaze,eyes,pred);
        u=u+1;
    end
end
sum(l2_distance)/nnz(l2_distance)
check=isnan(angular_error);
ii=find(check==1);
angular_error(ii)=0;
sum(angular_error)/nnz(angular_error)    

