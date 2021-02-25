% This is the main function which gives the final detected centers ('cen')
% as output

%input_path = 'Hua167/'; %%Path of input directory
% input_dir = '/home/samik/mnt/gpu5b_1/nfs/data/main/M28/HuaDataFromBA/';
function main(input_brain)
    input_dir = '/home/samik/mnt/gpu5b_1/nfs/data/main/M28/HuaDataFromBA/';
%     input_dir = '/nfs/data/main/M28/HuaDataFromBA/';
    %input_brain = 'Hua150/';
    input_path = [input_dir input_brain];
    output_dir =  '/home/samik/mnt/gpu5b_1/nfs/data/main/M32/Cell_Counting/';
%     output_dir =  '/nfs/data/main/M32/Cell_Counting/';
    save_dir = 'temp/';
    output_path = [output_dir input_brain];
    % mkdir(output_path);
    %output_path = 'output/'; %% Path of output directory where final outputs are stored

    d=dir([input_path '*F*.jp2']);
%     d2=dir([output_path '*F*.mat']);
%     disp(length(d))
    addpath(genpath('frangi_filter_version2a/'));

    for i=1:length(d)
        if ~exist([output_path strrep(d(i).name, 'jp2', 'mat')], 'file') % Avoid duplicate process 
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

            %% Save remote files
            save([save_dir sec_name '.mat'], 'cen');
            remote_host = '';
            remote_user = '';
            pswd = '';
            remote_dir = ['/nfs/data/main/M32/Cell_Counting/' input_brain];
            ssh_cmd = ['sshpass -p ' pswd ' ssh ' remote_user remote_host ' mkdir -p ' remote_dir ];
            scp_cmd = ['sshpass -p ' pswd ' scp ' save_dir ...
                strrep(sec_name, '&', '\&') '.mat ' ...
                remote_user remote_host ':' remote_dir ];
            system(ssh_cmd);
            system(scp_cmd);


            %% Clear temporary data
            rm_cmd = ['rm ' save_dir strrep(sec_name, '&', '\&') '.mat'];
            system(rm_cmd);
            clear('cen');
            clear('fgr');
            clear('img');
            clear('cen_p1');
        end
    end
end
%%


