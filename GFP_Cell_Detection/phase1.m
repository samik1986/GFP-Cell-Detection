%This function contains Phase 1 sub-process which gives initial set of cell
%centers

%{
%-------------------------------------------------------------------------
INPUTS

'img': Fore-ground Region - FGR (size:m x n)
'param': Hyperparameters -threshold, area and avg_radius (each being
            a scalar value)
'bin_img': Binarized FGR (size: m x n)
'ed': Edge detected FGR (size: m x n)
%-------------------------------------------------------------------------
OUTPUTS

'cen_p1': cell centers detected from the Phase 1 sub-process 
          (size:c x 2 where each row gives xy coordinates of a cell center)
'mdt': Modulated Distance Transform which is the weighted product of
        Distance Transform (DT) and Fore-ground region (FGR) (size: m x n)
%-------------------------------------------------------------------------
%}

function [cen_p1,mdt]=phase1(fgr, param, bin_img, ed)
% figure, imshow(fgr), title('FGR');
% figure, imshow(bin_img), title('binary image');
% figure, imshow(ed), title('edge image');
dt=bwdist(ed); 
mdt=(0.9*(dt.*bin_img))+(0.1*(double(fgr)/double(max(max(fgr)))));  %mDT
%figure; imshow(mdt, []), title('mDT');

temp=mdt;
temp(temp<0.8)=0;
cc=bwconncomp(temp);
pxlist=regionprops(cc, 'PixelList');
for i=1:length(pxlist)
    px=pxlist(i).PixelList;
    if size(px,1)<2
        for j=1:size(px,1)
            temp(px(j,2), px(j,1))=0;
        end
    end
end

%% Finding Peaks of DT Map
ind2=imregionalmax(temp);
cc=bwconncomp(ind2,8);
s=regionprops(cc,'centroid');
centroids=[s.Centroid];
x=centroids(1:2:end-1);
y=centroids(2:2:end);
cen=[x;y]'; 
cen=cluster(cen,12);          %peaks of mDT map

%% Calculating Ridge Bifurcation Points (Comment this section for switching off Ridge processing)
temp1=bin_img;
cc=bwconncomp(temp1);
pxlist=regionprops(cc, 'PixelList');
area=round(1.5*3.14*param.avg_radius*param.avg_radius);
for i=1:length(pxlist)
    px=pxlist(i).PixelList;
    if size(px,1)<=area
        for j=1:size(px,1)
            temp1(px(j,2), px(j,1))=0;
        end
    end
end

ed1=edge(im2double(temp1)); 
dt1=bwdist(ed1); 
mdt1=(0.9*(dt1.*temp1))+(0.1*(double(fgr)/double(max(max(fgr))))); 

bp=[];
setd=[];

tp=temp1/max(max(mdt1));
Ridge=Vessels(tp);      %Calculate Ridge
skel= bwmorph(Ridge,'skel',Inf);       
%skel=skel & img;

B = bwmorph(skel, 'branchpoints');  
E = bwmorph(skel, 'endpoints');
[ey,ex] = find(E);
[t2 t1]=find(B);
[e2,e1]=find(ed);

ep=[ex ey];
bp=[t1 t2];     %Bifurcation Points
edg=[e1,e2];

%Remove centers that are very close to the cell border
[d1,d2]=find(pdist2(bp,edg)<=5); 
d_bp=bp(d1,:);
C=intersect(bp,d_bp,'rows');
setd=setdiff(bp,C,'rows');

%% Clustering Points
cen_p1=[cen;setd];
cen_p1=cluster(cen_p1,6);
cen_p1=round(cen_p1);
% figure, imshow(img), title('Phase1 output'); 
% hold on 
% plot(cen_p1(:,1),cen_p1(:,2),'r.','MarkerSize',15); 
% hold off 
end
