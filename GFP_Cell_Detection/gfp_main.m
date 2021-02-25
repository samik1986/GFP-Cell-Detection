% This is the main function which gives the final detected centers ('cen')
% as output


input_dir = 'HuaDataFromBA/';
input_brain = 'Hua32/';
input_path = [input_dir input_brain];
save_dir = 'temp/';


d=dir([input_path '*F*.jp2']);

addpath(genpath('frangi_filter_version2a/'));

for i=1:length(d)
    [~, sec_name, ~]=fileparts(d(i).name);
    disp(sec_name);
    img=imread([input_path d(i).name]);
    
    %% Initializing Hyperparameters
    param.threshold = 0.25; %%Threshold for binarizing (empirically best value)
    param.area = 50; %%Minimum Area covered by a cell
    param.avg_radius = 6; %%Average cell area
    
    %% Phase 1
    % Intial pre-processing to get the fore-ground region (FGR)
    fgr=pre_proc(img(:,:,2));
    [cen_p1,mdt,bin_img]=phase1(fgr, param);
    
    %% Phase 2
    [cen]=phase2(fgr,mdt,cen_p1,param,bin_img);
    
    %% Displaying the centers
    %     figure, imshow(uint8(img)), title('Final detected centers after phase1 and phase2');
    %     hold on
    %     plot(cen(:,1), cen(:,2), 'r.','MarkerSize',15);
    %% Save the output and clear the buffer variables.
    save([output_path sec_name '.mat'], 'cen');
    
   
    
    %% Clear temporary data
    clear('cen');
    clear('fgr');
    clear('img');
    clear('cen_p1');
end

