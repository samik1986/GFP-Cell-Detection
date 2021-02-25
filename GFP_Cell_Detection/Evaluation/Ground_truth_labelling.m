%This function is used to calculate true positives, false positives, amd
%false negatives given manually annoated cell centers and the centers
%detected by the algorithm

%{
%-------------------------------------------------------------------------
INPUTS

'cen' - predicted cell centers (size: c x 2)
'final' - Ground Truth cell centers (size: d x 2)
%-------------------------------------------------------------------------
OUTPUTS

't_p' - true postives (size: p x 2)
'f_p' - false postives (size: q x 2)
'f_n' - false negatives (size: r x 2)
%-------------------------------------------------------------------------
%}

function [ t_p, f_p, f_n] = Ground_truth_labelling( cen, final )

t_p=[];
f_p=[];
f_n=[];
f_tp = [];

for i=1:size(cen,1)
    if (size(final,1)>0)
        temp=cen(i,:);
        d=pdist2(temp, final);
        [a b]=min(d);
        if (a<7)
            t_p=[t_p; temp];
            f_tp = [f_tp; final(b(1),:)];
            final(b(1),:)=[];
        end
        % %     cen(1,:)=[];
       
    else
        break;
    end
end

f_p=setdiff(cen,t_p, 'rows');

f_n=setdiff(final, f_tp, 'rows');
end
