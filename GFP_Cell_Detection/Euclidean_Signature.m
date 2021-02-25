
% This function computes an approximate Euclidean signature 
% Modified slightly from code by Joe Kenney
%{
%--------------------------------------------------------------------
INPUTS
%--------------------------------------------------------------------

'curve':    This should be a discretized planar curve of n points 
            represented as an n-by-2 matrix, each row of which 
            specifies a point in R^2. The curve is assumed to be 
            closed; no repetition of points is necessary.
%--------------------------------------------------------------------


%--------------------------------------------------------------------
OUTPUTS
%--------------------------------------------------------------------

'signature':This n-by-2 matrix represents the approximate Euclidean 
            signature of 'curve'. Each row specifies a point in R^2. 

%--------------------------------------------------------------------
%}



function [signature, arcLength] = Euclidean_Signature(curve)

% Extract coordinates
x = curve(:, 1);
y = curve(:, 2);

[sz, ~] = size(x);
% Arc Length Calculation
arcLength = zeros(sz, 1);
arcLength(1) = sqrt((x(1)-x(sz))^2 + (y(1)-y(sz))^2);
for i = 2 : sz
    arcLength(i) = arcLength(i-1)+sqrt((x(i)-x(i-1))^2 + (y(i)-y(i-1))^2);
end

dx = circshift(x,[-1 0]) - x; % Forward difference
dy = circshift(y,[-1 0]) - y; % Forward difference
bdx = -circshift(dx,[1 0]); % Backward difference
bdy = -circshift(dy,[1 0]); % Backward difference

b = sqrt(dx.^2+dy.^2);
a = circshift(b,[1 0]); % one behind
d = circshift(b,[-1 0]); % one ahead
g = circshift(b,[ 2 0]); % 2 behind
d2x = circshift(x,[-1 0]) - circshift(x,[1 0]);
d2y = circshift(y, [-1 0]) -circshift(y,[1 0]);

c = sqrt(d2x.^2+d2y.^2);

% Compute signed area using the cross product

va = [dx dy zeros(sz,1)];
vb = [bdx bdy zeros(sz,1)];
Area = .5*cross(va, vb);
Area = Area(:, 3);

% Compute approximate curvature
kappa = 4*(Area)./(a.*b.*c);

% Approximate arc length derivative of curvature
kappad = circshift(kappa,[-1 0]) - kappa;
kappad = (3/2)*((kappad)./(a+b+d) +  (circshift(kappad,[1 0]))./(a+b+g)); % Averaging 2 forward differences. 

% Assign output
signature =  [kappa kappad];
% disp(size(signature));   
   
end

 
