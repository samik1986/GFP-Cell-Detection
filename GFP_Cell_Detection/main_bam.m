% This is the main function which gives the final detected centers ('cenF')
% as output

function main_bam(input_brain)
warning off;
input_brain = 'Hua153/';
input_path = [input_brain erase(input_brain,"/") '_img/'];
output_dir = 'Cell_Counting/';
seg_dir = [input_brain '/reg_high_seg/'];
output_path = [output_dir input_brain]; %% Path of output directory where final outputs are stored
mkdir(output_path);

d=dir([input_path '*F*.jp2']);
addpath(genpath('frangi_filter_version2a/'));

for i=1:length(d)
    if ~exist([output_path strrep(d(i).name, 'jp2', 'json')], 'file') % Avoid duplicate process
        %if ~exist([save_dir input_brain strrep(d(i).name, 'jp2', 'mat')], 'file')
             try
                [~, sec_name, ~]=fileparts(d(i).name);
                disp(sec_name);
                img=imread([input_path d(i).name]);

                %% Intial pre-processing with green channel image
		img_g_preproc=pre_proc(img(:,:,2));
                
                %% Load the original image mask file
                load([seg_dir strrep(d(i).name, 'jp2', 'mat')]);
                seg = uint8(imbinarize(seg)*255);
                
                %% Initializing Hyperparameters
                param.threshold = 0.25; %%Threshold for binarizing (empirically best value)
                param.area = 25; %%Minimum Area covered by a cell
                param.avg_radius = 4; %%Average cell area
                
		%% Initialize Final cell centers
		cenF = [];
                
                for row =1:1024:size(img,1)-1023 %splitting input image into 1024*1024 tiles
                    for col =1:1024:size(img,2)-1023
                        
			% Check if the segmented mask contains brain region
                        tissue_exist = find(seg(row:row+1023,col:col+1023,:) == 255);
                        
                        if ~isempty(tissue_exist) %Process cell detection on the tile only if the tissue exists
			    
			    % Get the respective tile regions for further processing
                            fgr_tile = img_g_preproc(row:row+1023,col:col+1023);
                            seg_img_tile = seg(row:row+1023,col:col+1023);
			    
			    % Avoiding noise outside the segmented region
                            fgr_tile(seg_img_tile == 0) = 0;
			    
			    % Generating binary and edge images from the FGR tile
                            bin_img_tile=im2bw(fgr_tile, param.threshold);
                            ed_tile=edge(im2double(bin_img_tile));
                            
                            if any(ed_tile(:)) %Check if any edges is present in the tile
				%% Phase 1
                                [cen_p1,mdt]=phase1(fgr_tile,param,bin_img_tile,ed_tile);
                                %% Phase 2
                                [cen]=phase2(fgr_tile,mdt,cen_p1,param,bin_img_tile);
				%% Final cell centers
                            	cenF = [cenF; cen(:,2)+row,  cen(:,1)+col];
                            end
                        
                        end
                    end
                end
                
                %% Displaying the centers
                %     figure, imshow(uint8(img)), title('Final detected centers after phase1 and phase2');
                %     hold on
                %     plot(cen(:,1), cen(:,2), 'r.','MarkerSize',15);
                %% Save the output and clear the buffer variables.
                %             save([output_path sec_name '.mat'], 'cen');
                
                %% Save remote files
                %save([output_path sec_name '.mat'], 'cenF');
		%disp('.mat saved');

		%% Save the final cell centers within a JSON file
                fID = fopen([output_path sec_name '.json'],'w');
                fprintf(fID, '{"type":"FeatureCollection","features":[{"type":"Feature","id":"1","properties":{"name":"GFP Cell"},"geometry":{"type":"MultiPoint","coordinates":[');

                for row = 1:length(cenF)
                    fprintf(fID, '[');
                    fprintf(fID, '%d,%d', int32(cenF(row,2)), int32(-cenF(row,1)));
                    if row==length(cenF)
                        fprintf(fID, ']');
                    else
                        fprintf(fID, '],');
                    end
                end
                fprintf(fID,']}}]}');
                fclose(fID);
		
                clear('fgr_tile');
		clear('seg_img_tile');
		clear('bin_img_tile');
		clear('ed_tile');
                clear('cen_p1');
		clear('cen');
		clear('tissue_exist');
		clear('img');
		clear('img_g_preproc');
		clear('seg');
             catch
                 disp('Error within main_bam');
             end
        %end
    end
end
end

