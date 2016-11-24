clear all
close all
clc
load('train_annotations.mat');
% remove=[];
% for i=1:size(train_path,1)
%     gt_gaze2=cell2mat(train_gaze(i));
%     if ~(0<=gt_gaze2(1)<=1 || 0<=gt_gaze2(2)<=1)
%         remove=[remove;i];
%     end
% end
[data2,path2]=xlsread('train_gaze.xlsx');
u=1;
j=1;
p=sort(path2);
while u<=size(p,1)
    u
    close all
    index=find(strcmp(path2,p(u)));
    index2=find(strcmp(train_path,p(u)));
    v=size(index2,1);
    x=size(index,1);
if v>1
   for w=1:v
    eye_center2=train_eyes(index2(w));
    pred_gaze2=data2(index(w),3:4);
    gt_gaze2=cell2mat(train_gaze(index2(w)));
    l2_distance2(j)=calculate_distance(gt_gaze2,pred_gaze2);
    angular_error(j,:)=calculate_angular_error(cell2mat(eye_center2),gt_gaze2,cell2mat(eye_center2),pred_gaze2);
%         im=imread(cell2mat(p(u)));
%         g = floor(pred_gaze2.*[size(im,2) size(im,1)]);
%     g2= floor(gt_gaze2.*[size(im,2) size(im,1)]);
%     e = floor(cell2mat(eye_center2).*[size(im,2) size(im,1)]);
%         figure
%         imshow(im), hold on;
%     plot(e(1), e(2), '*');
%     line([e(1), g(1)], [e(2) g(2)],'Color','y');
%     drawnow;
%     hold on 
%     line([e(1), g2(1)], [e(2) g2(2)],'Color','r');
%     drawnow;
%     pause(1)
 j=j+1;
   end
%    break;
end
    u=u+v;
   
end
sum(l2_distance2)/nnz(l2_distance2)
check=isnan(angular_error);
ii=find(check==1);
angular_error(ii)=0;
sum(angular_error)/nnz(angular_error)
