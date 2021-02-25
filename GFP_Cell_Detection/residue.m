%This function computes Residual Fore-ground Map (RFM)

%{
%-------------------------------------------------------------------------
INPUTS

'fgr': Fore-ground Region - FGR (size:m x n)
'cen_p1': cell centers detected from the Phase 1 sub-process 
          (size:c x 2 where each row gives xy coordinates of a cell center)
'avg_radius, area': Hyperparameters for cell radius and area 
                    (scalar values)
%-------------------------------------------------------------------------
OUTPUTS

'rfm_final': Residual Foreground Map (RFM) used in Phase 2 subprocess 
             (size: m x n)
%-------------------------------------------------------------------------
%}

function [rfm_final]= residue(fgr, cen_p1, avg_radius, area)
avg_radius=avg_radius*ones(1, size(cen_p1,1)); 
cen_p1=round(cen_p1); 

tp=bwconncomp(fgr);
tp=regionprops(tp, 'PixelList');
zr=[];
for i=1:size(tp,1)
    pts=tp(i).PixelList;
    if (size(pts,1)<20)
        zr = [zr; pts];
    else
        [d e]=intersect(cen_p1, pts, 'rows');
        f=avg_radius(e);
        for j=1:size(d,1)
            val=f(j)+3;
            dst=pdist2(d(j,:), pts);
            zr=[zr; pts(dst<val,:)];
        end
    end    
end


rfm=fgr;
for j=1:size(zr,1)
    rfm(zr(j,2), zr(j,1))=0;
end
rfm=im2double(rfm);
cc=bwconncomp(rfm, 8);
%% Removing the small connected components
cc1=regionprops(cc, 'PixelList');
zr=[];
count=0;
for i=1:length(cc1)
    temp=cc1(i).PixelList;
    if size(temp,1)<area
        zr=[zr; temp];
        count=count+1;
    end
end
rfm_final=rfm;
if size(zr, 1)>0
    zr=swap(zr);
    rfm_final=rfm;
    for j=1:size(zr,1)
        rfm_final(zr(j,1), zr(j,2))=0;
    end
end
end
