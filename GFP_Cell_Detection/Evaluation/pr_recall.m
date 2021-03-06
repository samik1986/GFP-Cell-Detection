%Finds the average precision recall obtained over all sections of a brain

%{
Given the folder containing ground truth centers and predicted cell centers
average precision and recall are obtained as output
%}

output_path = '/media/vplab/CCBR_1/data/results_obtained_stored/finalpts167_from_giri_backup/'; %% Path of detected centres
output_path_final = '/media/vplab/CCBR_1/data/brains/GFP/Annotations/Hua167_annotation/'; % Path of GT
d=dir([output_path '*.mat']);
d1=dir([output_path_final '*.mat']);
fid = fopen('/media/vplab/CCBR_1/data/results_obtained_stored/Hua167_check','w');
for i=1:length(d1)
    %% 
    [~, name, ~]=fileparts(d(i).name);
    [~, name_fin, ~]=fileparts(d1(i).name);
    
    disp(name); %%Displaying name of current processing image

    %% Loading GT
    final1=load([output_path_final name '.mat']);
    if(isfield(final1,'cen'))
        final=final1.cen;
    elseif(isfield(final1,'D'))
        final=final1.D;
    end
    
    %% Loading found out centroid 
      cen=load([output_path name '.mat']);
      cen=cen.cen;
    
    %% 
    %%% Calculating precision recall for each image
         [tp,fp,fn]=Ground_truth_labelling(cen,final);
         TP(i)=size(tp,1);
         FP(i)=size(fp,1);
         FN(i)=size(fn,1);
%          FINAL(i)=size(final,1);
%          CEN(i)=size(cen,1);
         pr(i)=size(tp,1)/(size(tp,1)+size(fp,1))*100;
         recall(i)=size(tp,1)/(size(tp,1)+size(fn,1))*100;
         
    % Writing pr recall to a file
    fprintf(fid,'%s ',name);
    fprintf(fid, '%0.4f ',pr(i));
    fprintf(fid,'%0.4f \n',recall(i));
%% Clearing data

clear('final')
clear('cen')
end
 
%% Overall precision recall
precision=mean(pr);
rec=mean(recall);
% fprintf('Precision:%0.4f \n',precision);
% fprintf('Recall:%0.4f \n',rec);
