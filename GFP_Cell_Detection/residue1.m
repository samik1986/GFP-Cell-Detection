%This function computes Residual Fore-ground Map (RFM)

%{
%-------------------------------------------------------------------------
INPUTS

'rfm': Fore-ground Region - FGR (size:m x n)
'p2_centers': cell centers detected from previous iteration of 
              phase 2 sub-process 
          (size:c x 2 where each row gives xy coordinates of a cell center)
'avg_radius, area': Hyperparameters for cell radius and area 
                    (scalar values)
%-------------------------------------------------------------------------
OUTPUTS

'rfm_final': Residual Foreground Map (RFM)
             (size: m x n)
%-------------------------------------------------------------------------
%}

function [rfm_final]= residue1(rfm, p2_centers, avg_radius,area)
tp=bwconncomp(rfm);
% % c=c*ones(1, size(b,1));
p2_centers=round(p2_centers);
% % for i=1:size(b,1)
% %     c(i)=dist(b(i,2), b(i,1))-1;
% % end
% % edge=imcontour(and,1);
% % edge=edge(:, 2:end-1);
% % [x y]=find(and~=0);
% % z=[y x];
% % [b e]=intersect(b, z, 'rows');
% % c=c(e);
tp=regionprops(tp, 'PixelList');
zr=[];
for i=1:size(tp,1)
    pts=tp(i).PixelList;
    if (size(pts,1)<20)
        zr = [zr; pts];
    else
        dst = pdist2(p2_centers,pts);
        for j=1:size(p2_centers,1)
%             disp([num2str(i) ':' num2str(j)]);
            zr=[zr; pts(dst(j,:)<avg_radius,:)];
        end 
%         i = j;
    end
end


rfm1=rfm;
for j=1:size(zr,1)
    rfm1(zr(j,2), zr(j,1))=0;
end

rfm1=im2double(rfm1);

% % h=gaussFun(0.5);
% % gil1=conv2(h,h,gil,'same');
% % gilg=im2bw(gil1, 0.5);
% % gilg=double(gilg);
cc=bwconncomp(rfm1, 8);

% % rad=min(c);
% % area=pi*rad*rad;
% % area=50;
%% Removing the small connected components
cc1=regionprops(cc, 'PixelList');
zr=[];
for i=1:length(cc1)
    temp=cc1(i).PixelList;
%     if size(temp,1)<area
        zr=[zr; temp];
%     end
end
rfm_final=rfm1;
if size(zr, 1)>0
    zr=swap(zr);
    rfm_final=rfm1;
    for j=1:size(zr,1)
        rfm_final(zr(j,1), zr(j,2))=0;
    end
end
% figure, imshow(gil);
