%This function contains Phase 2 sub-process which gives the final set of
%cell centers

%{
%-------------------------------------------------------------------------
INPUTS

'img': Fore-ground Region - FGR (size:m x n)
'mdt': Modulated Distance Transform which is the weighted product of
        Distance Transform (DT) and Fore-ground region (FGR) (size: m x n)
'cen_p1': cell centers detected from the Phase 1 sub-process
          (size:c x 2 where each row gives xy coordinates of a cell center)
'param': Hyperparameters -threshold, area and avg_radius (each being
            a scalar value)
'bin_img': Binarized FGR (size: m x n)
%-------------------------------------------------------------------------
OUTPUTS:

'final_cen': cell centers detected from the Phase 2 sub-process
          (size:d x 2 where each row gives xy coordinates of a cell center)
%--------------------------------------------------------------------------
%}

function [final_cen]=phase2(fgr,mdt,cen_p1,param,bin_img)
%% Arc Based Iteration
p2_centers=[];
%Compute RFM
[rfm] = residue(fgr, cen_p1, param.avg_radius, param.area);
% figure, imshow(rfm), title('RFM');
cc=bwconncomp(rfm);
try
    while(cc.NumObjects>0)
        %     disp(cc.NumObjects);
        [IEC, OBC] = edge_layers(rfm, cen_p1, mdt);
        p2_centers = [p2_centers; cell_filling(rfm, OBC, bin_img)];
        [rfm] = residue1(rfm, p2_centers, 15, param.area);
        cc = bwconncomp(rfm);
    end
catch
    disp('Inside phase2 catch');
%     [IEC, OBC] = edge_layers(rfm, cen_p1, mdt);
%     p2_centers = [p2_centers; cell_filling(rfm, OBC, bin_img)];
end
%% Merging Final Set of Cell Centers
final_cen=[cen_p1;p2_centers];
final_cen=cluster(final_cen,8);
end