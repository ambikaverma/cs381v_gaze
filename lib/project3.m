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
    j=size(index,1);
    for k=1:j
    eye_center=test_eyes(index(k));
    pred_gaze=data(i+k-1,3:4);
    gt_gaze=cell2mat(test_gaze(index(k)));
    avg_gt_gaze(i+k-1,:)=mean(gt_gaze);
    l2_distance(i+k-1,:)=calculate_distance(avg_gt_gaze(i+k-1,:),pred_gaze);
    
    im=imread(cell2mat(path(i)));
    g = floor(pred_gaze.*[size(im,2) size(im,1)]);
    g2= floor(avg_gt_gaze(i+k-1,:).*[size(im,2) size(im,1)]);
    e = floor(cell2mat(eye_center).*[size(im,2) size(im,1)]);
    gaze = [e(1) e(2) g(1) g(2)];
    % im = insertShape(im,'line',line,'Color','red','LineWidth',8);

    imshow(im), hold on;
    plot(e(1), e(2), '*');
    line([e(1), g(1)], [e(2) g(2)],'Color','y');
    drawnow;
    hold on
    line([e(1), g2(1)], [e(2) g2(2)],'Color','r');
    drawnow;
    end
    
    i=i+j;
    
    
end
mean(l2_distance)    

[data2,path2]=xlsread('train_gaze.xlsx');
u=1;
while u<=size(path2,1)
    u
    index2=find(strcmp(train_path,path2(u)));
    v=size(index2,1);
    for w=1:v
    eye_center2=train_eyes(index2(w));
    pred_gaze2=data2(u+w-1,3:4);
    gt_gaze2=cell2mat(train_gaze(index2(w)));
    avg_gt_gaze2(u+w-1,:)=mean(gt_gaze2);
    l2_distance2(u+w-1,:)=calculate_distance(avg_gt_gaze2(u+w-1,:),pred_gaze2);
    end
    u=u+v;
end

mean(l2_distance)
mean(l2_distance2)