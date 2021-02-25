%This function computes Inner Boundary Contours (IBC) and Outer Boundary
%Contours (OBC)

%{
%-------------------------------------------------------------------------
INPUTS

'rfm': Residual Foreground Map (RFM) used in Phase 2 subprocess 
       (size: m x n)
'cen_p1': cell centers detected from the Phase 1 sub-process 
          (size:c x 2 where each row gives xy coordinates of a cell center)
'mdt': Modulated Distance Transform which is the weighted product of
        Distance Transform (DT) and Fore-ground region (FGR) (size: m x n)
%-------------------------------------------------------------------------
OUTPUTS

'IBC': Inner Boundary Contours (size:p x 2)
'OBC': Outer Boundary Contours (size:q x 2)
%-------------------------------------------------------------------------
%}

function [IBC, OBC] = edge_layers( rfm, cen_p1, mdt )
%%
h=gaussFun(1);
sig_map=conv2(h,h,rfm, 'same'); % Gives gaussian blur
ed=edge(sig_map); % edges of the RFM

%%
pts=[];
for i=1:length(cen_p1)
    try
        val=mdt(round(cen_p1(i,2)), round(cen_p1(i,1)))+4.5;
        
    catch er
        disp(er)
    end
    pts=[pts; eval_pts([cen_p1(i,2), cen_p1(i,1)], val)];
end

[m,n]=find(ed==1);
p=[n,m];

IBC=intersect(p, pts, 'rows'); % finding IEC
OBC=setdiff(p, IBC, 'rows'); % finding OBC
end
