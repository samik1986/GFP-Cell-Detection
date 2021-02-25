function [xc]=zcc(s1, s2)
xc=[];
if find(s1~=0)
    s2=s2';
    y=s1(:,1);
    x=s2;
    n = length(y);
    ind = 1:(n-1);
    k = find(((y(ind)<=0) & (y(ind+1)>0)) | ...
        ((y(ind)>=0) & (y(ind+1)<0)));
    xc = [];
    L = (y(k)==0) & (y(k+1)==0);
    if any(L)
        xc = x(k(L));
        k(L)=[];
    end
    
    if ~isempty(k)
        s = (y(k+1)-y(k))./(x(k+1)-x(k));
        xc = [xc,x(k) - y(k)./s];
    end
    
    if y(end)==0
        xc(end+1) = x(end);
    end
%      disp(size(xc)); % It is a vector
end
