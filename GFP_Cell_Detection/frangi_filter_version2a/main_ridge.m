clear all
close all
I1=(imread ('ridge.png'));
I=double(rgb2gray(I1));
figure, surf(I,'EdgeColor','none','LineStyle','none','FaceLighting','phong')
options.FrangiScaleRange = [1 1];
options.BlackWhite = false;
[Ivessel, whatScale, Direction]=FrangiFilter2D(I, options);
figure,
subplot(1,2,1), imshow(I,[]);
subplot(1,2,2), imshow(Ivessel,[0 0.25]);

% Ivessel = nonmaxsup(Ivessel, Direction, 5);
% figure,
% subplot(1,2,1), imshow(I,[]);
% subplot(1,2,2), imshow(Ivessel,[0 0.25]);

valuethresh = graythresh( Ivessel );
bwridge = im2bw( Ivessel, valuethresh ); 
figure, surf(double(bwridge),'EdgeColor','none','LineStyle','none','FaceLighting','phong')
bwridge = bwmorph(bwridge, 'skel', Inf);
bwridge1 = bwareaopen(bwridge, 1);
figure,
subplot(1,2,1), imshow(I,[]);
subplot(1,2,2), imshow(bwridge1,[0 1]);
I2 = I1;
[a(:,1), a(:,2)] = find(bwridge1 == 1);
for i = 1:length(a)
I2(a(i,1),a(i,2),1) = 255;
I2(a(i,1),a(i,2),2:3) = 0;
end
figure, imshow(I2);
% BW = im2bw(Ivessel, 0.12);
% figure, imshow(BW)
% BW3 = bwmorph(BW,'skel',Inf);
% figure
% imshow(BW3)