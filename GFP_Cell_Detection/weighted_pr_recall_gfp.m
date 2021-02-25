% function [precision,rec]=pr_recall_fast_blue()

%% 
% input_path = '/media/vplab/CCBR_1/data/brains/GFP/Brains/Hua_registered_brains/Hua167/'; %%Path of input directory
% input_path_orig= '/media/vplab/CCBR_1/fast_blue/annotation/M917-F39--_1_0115/Away_injection_spot/img/';
output_path = '/media/vplab/E_new/RCNN/Detections_mat_v2/'; %% Path of detected centres
output_path_final = '/media/vplab/E_new/RCNN/Annotations_mat/'; % Path of GT
d=dir([output_path '*.mat']);
% d=natsortfiles({Di.name});
d1=dir([output_path_final '*.mat']);
d1=d1(149454:end);
% d1=natsortfiles({D1.name});

% fid = fopen('/media/vplab/CCBR_1/data/results_obtained_stored/Hua166_cell_count_gt.txt','w');
fid1 = fopen('/media/vplab/CCBR_1/data/results_obtained_stored/Hua167_RCC_v2.txt','w');

max_cell_count=0;
sum_cell_count=0;
for i=1:length(d1)
    [~, name, ~]=fileparts(d(i).name);
    [~, name_fin, ~]=fileparts(d1(i).name);
    name_img=strcat(name,'.jp2');

    %% Loading GT
    name1=strcat(name_fin,'.mat');    
    final1=load([output_path_final name1]);
    if(isfield(final1,'cen'))
        final=final1.cen;
    elseif(isfield(final1,'a'))
        final=final1.a;
    end
    cell_count=size(final,1);
%     fprintf(fid,'%s ',name);
%     fprintf(fid, '%d \n',cell_count);
%     if(cell_count>max_cell_count)
%         max_cell_count=cell_count;
%         name_max_cell_count=name1;
%     end
    sum_cell_count=sum_cell_count+cell_count;

end
% 
% disp('The section with maximum cell count is ');
% disp(name_max_cell_count);

for i=1:length(d1)
    %% 
%     disp(length(d));
%     disp(length(d1));
    [~, name, ~]=fileparts(d(i).name);
    [~, name_fin, ~]=fileparts(d1(i).name);
    
%     disp(name); %%Displaying name of current processing image
    name_img=strcat(name,'.jp2');
    disp(name_img);
%     img=imread([input_path name_img]);
%     img1=uint8(bitshift(img,-4));
%     
%     img2=zeros(size(img1));
%     img2(:,:,2)=histeq(img1(:,:,2),hist);
%     figure, imshow(uint8(img));
%     img1=imread([input_path_orig d(i).name]);
    

    %% Loading GT
    name1=strcat(name_fin,'.mat');
    disp(name1);
    final1=load([output_path_final name1]);
    if(isfield(final1,'cen'))
        final=final1.cen;
    elseif(isfield(final1,'a'))
        final=final1.a;
    end
    cell_count=size(final,1);
    
    %% Loading found out centroid 
%     cent=load([output_path name1]);
%     cen=cent.cen;
    name2=strcat(name,'.mat');
    disp(name2);
%     cen=csvread([output_path name2]);
      cen=load([output_path name2]);
      cen=cen.cen;
    
    %% 
    %%% Calculating precision recall for each image
         [tp,fp,fn]=Ground_truth_labelling_RCNN(cen,final);
         TP(i)=size(tp,1);
         FP(i)=size(fp,1);
         FN(i)=size(fn,1);
         FINAL(i)=size(final,1);
         CEN(i)=size(cen,1);
         pr(i)=size(tp,1)/(size(tp,1)+size(fp,1))*100;
         recall(i)=size(tp,1)/(size(tp,1)+size(fn,1))*100;
         
%          w(i)=cell_count/max_cell_count;
        w(i)=cell_count/sum_cell_count;
    % Writing pr recall to excel sheet

    fprintf(fid1,'%s ',name);
    fprintf(fid1, '%0.4f ',pr(i));
    fprintf(fid1,'%0.4f \n',recall(i));
   
    
    %%  Displaying the image with tp,fp,fn
%     figure, 
%     imshow(uint8(img)), title('hua167-200th section GT');
%     hold on
%     plot(D(:,1),D(:,2),'r.','MarkerSize',12);
%     hold off
 
%     figure, 
%     imshow(uint8(img2)), title('hua167-200th section code output');
%     hold on
%     plot(cen(:,1),cen(:,2),'r.','MarkerSize',12);
%     hold off
%     
%    figure, 
%     imshow(uint8(img));
%     hold on
%     plot(tp(:,1), tp(:,2), 'b.','MarkerSize',12);
%     plot(fp(:,1), fp(:,2), 'r*','MarkerSize',12,'Linewidth',4);
%     plot(fn(:,1), fn(:,2), 'w+','MarkerSize',12,'Linewidth',4);
%     hold off

%% Clearing data

%   clear('final');
  clear('CC');
  clear('S');
  clear('ground_cell');
%   clear('cen');
  clear('x');
  clear('y');
  clear('centroids');
end
 
%% Overall precision recall
precision=sum(w.*pr);
rec=sum(w.*recall);
% fprintf('Precision:%0.4f \n',precision);
% fprintf('Recall:%0.4f \n',rec);
% disp('----------------------------------------');


% figure, 
% x=linspace(1,251,251);
% plot(x,TP,'b');
% hold on
% plot(x,FN,'k');
% plot(x,FP,'r');
% hold off
% 
% figure, 
% plot(x,FINAL,'k');
% hold on
% plot(x,CEN,'r');