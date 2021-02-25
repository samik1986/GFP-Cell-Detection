%This function does the pre-processing and gives the fore-ground region as
%output

%{
%------------------------------------------------------------
INPUTS

'img': green channel of the brain section (size:m x n)
%------------------------------------------------------------
OUTPUTS

'fgr': fore-ground region (size:m x n)
%------------------------------------------------------------
%}

function [fgr]=pre_proc(img)

norm_img=normal(img);                               %normalized image
% figure, imshow(src), title('After normalization');

fgr=imadjust(norm_img,stretchlim(uint8(img)),[]);    %FGR
%figure, imshow(fgr,[]);
end
