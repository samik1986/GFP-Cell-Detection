%This function gives potential cell centers detected through cell filling
%by convex arcs that were not detected in phase 1 sub process

%{
%------------------------------------------------------------------------
INPUTS

'rfm': Residual Foreground Map (RFM) (size: m x n)
'OBC': Outer Boundary Contours (size: c x 2)
'bin_img': Binarized FGR (size: m x n)
%-------------------------------------------------------------------------
OUTPUTS

'p2_centers': cell centers detected by cell filling in phase 2 sub process
          (size:c x 2 where each row gives xy coordinates of a cell center)
%--------------------------------------------------------------------------
%}

function [p2_centers] = cell_filling(rfm, OBC, bin_img)
conncomp = zeros(size(rfm));
for i=1:length(OBC)
    conncomp(OBC(i,2), OBC(i,1)) = 255;
end
temp = zeros(size(rfm));
p2_centers=[];
r=[];
cc=bwconncomp(conncomp);
cc=regionprops(cc, 'PixelList');
zc=[];
c1=[];
r1=[];
z=[];
for i=1:length(cc)
    px = cc(i).PixelList;
    if size(px,1) > 15
        [c1, r1, z] = fit_circles(px);
    end 
    p2_centers = [p2_centers; c1];
    r = [r; r1];
    zc = [zc; z];
end

%% Replace centers having >1024 value with 1024
p2_centers(p2_centers>1024)=1024;
p2_centers(p2_centers<1)=1;

val=[];
%disp(size(p2_centers));
for i=1 : size(p2_centers, 1)
	if(p2_centers(i,2)>size(rfm,1) ||p2_centers(i,2)<1 || p2_centers(i,1)<1 || p2_centers(i,1)>size(rfm,2))
		disp('Value out of the range');
	else
    	val = [val; bin_img(p2_centers(i,2), p2_centers(i,1))];
	end
end
v = find(val==1);
p2_centers=p2_centers(v, :);
r=r(v);
[p2_centers, p]= unique(p2_centers, 'rows');
r= r(p);
p2_centers= round(p2_centers);
end
