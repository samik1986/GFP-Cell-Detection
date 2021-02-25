%This function does Ridge calculation (modified code 'main_ridge' in
%Frangi)

%{
%----------------------------------------------------------------------
INPUTS

'I': mDT map (size: m x n)
%----------------------------------------------------------------------
OUTPUTS

'Ridge': Ridge calculated to get Bifurcation points which are potential 
            cell centers (size: m x n)
%------------------------------------------------------------------------
%}


function [Ridge] = Vessels(I)
I1=im2uint8(I);
I1=cat(3,I1,I1,I1);
I=double(rgb2gray(I1));
clear('I1');
options.FrangiScaleRange = [1 1];
options.BlackWhite = false;
[Ivessel, Scale, Direction]=FrangiFilter2D(I, options);

Ivessel=imadjust(Ivessel);
h=gaussFun(2);
Iv=conv2(h,h,Ivessel,'same');
Ivessel=Iv;
clear('Iv');

Ivessel=imadjust(Ivessel);
valuethresh = graythresh( Ivessel );
bwridge = im2bw( Ivessel, valuethresh ); 
clear('Ivessel');


bwridge = bwmorph(bwridge, 'skel', Inf);
bwridge1 = bwareaopen(bwridge, 3);
clear('bwridge');
Ridge=bwridge1;
end

