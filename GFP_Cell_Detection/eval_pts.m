%This function is used to find the pixels which are on the boundary of the
%circles drawn to suppress cell areas which already got their centers
%detected in phase 1 (while creating RFM)

%{
%-------------------------------------------------------------------------
INPUTS

'cen': cell centers (size: c x 2)
'val': value used to find IBC 
%-------------------------------------------------------------------------
OUTPUTS

'pts': points on the boundaries of the circles drawn while creating RFM
        (size: d x 2)
%-------------------------------------------------------------------------
%}


function [ pts ] = eval_pts(cen, val )
temp=ones(30,30);
temp=temp>0;
cc=bwconncomp(temp);
tp=regionprops(cc, 'PixelList');
tp=tp.PixelList;

cen = [15,15];
dst = pdist2(cen ,tp);

pts = tp(dst<val, :);

pts (:,1) = pts(:,1)-15+cen(:,1);
pts (:,2) = pts(:,2)-15+cen(:,2);
end

