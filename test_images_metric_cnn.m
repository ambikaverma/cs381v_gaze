clear all
close all
clc
load('test_annotations.mat');
[data,path]=xlsread('test_gaze.xlsx');
load('train_annotations.mat');
path=sort(path);
i=1;
while i<=size(path,1)
    close all
    i
    index=find(strcmp(sort(test_path),path(i)));
    k=size(index,1);
    
    eye_center=test_eyes(index(k));
    pred_gaze=data(i+k-1,3:4);
    gt_gaze=cell2mat(test_gaze(index(k)));
    avg_gt_gaze(i+k-1,:)=mean(gt_gaze);
    l2_distance(i+k-1,:)=calculate_distance(avg_gt_gaze(i+k-1,:),pred_gaze);
    angular_error(i+k-1,:)=calculate_angular_error(cell2mat(eye_center),avg_gt_gaze(i+k-1,:),cell2mat(eye_center),pred_gaze);
    
    im=imread(cell2mat(path(i)));
    g = floor(pred_gaze.*[size(im,2) size(im,1)]);
    g2= floor(avg_gt_gaze(i+k-1,:).*[size(im,2) size(im,1)]);
    e = floor(cell2mat(eye_center).*[size(im,2) size(im,1)]);
    gaze = [e(1) e(2) g(1) g(2)];
    % im = insertShape(im,'line',line,'Color','red','LineWidth',8);
% figure
%     imshow(im), hold on;
%     plot(e(1), e(2), '*');
%     line([e(1), g(1)], [e(2) g(2)],'Color','y');
%     drawnow;
%     hold on
%     line([e(1), g2(1)], [e(2) g2(2)],'Color','r');
%     drawnow;
%     pause(3)
    
    i=i+k;
    
    
end
mean(l2_distance) 
mean(angular_error)
