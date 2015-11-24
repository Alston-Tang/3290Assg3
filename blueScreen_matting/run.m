
%%
% In this basic part, you should complete noblue.m, graymatt.m,
% triangulationmatt.m
%%
%part1: noblue matting
img   = im2double(imread('img/NOBLUE/01.png'));
alpha = noblue(img);
imshow(alpha);
pause;

%part2; gray matting
img = im2double(imread('img/GRAY/04.png'));
alpha = graymatt(img);
imshow(alpha)
pause;

%part3:trauangulation matting
img1 = im2double(imread('img/TRIANGULATION/01_1.png'));
img2 = im2double(imread('img/TRIANGULATION/01_2.png'));
alpha = triangulationmatt(img1,img2);
imshow(alpha);
pause;
