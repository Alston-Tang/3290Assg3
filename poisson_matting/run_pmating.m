
% input image
img     = im2double( imread('img/1.bmp') );
oriImg = img;

% input trimap
trimap  = im2double( imread('img/1-mask.bmp') );
trimap  = trimap(:,:,1);
% make trimap value to standard. 1 - foregournd; 0 - background; 0.5 - undecided.
trimap(trimap>0.8) = 1;
trimap(trimap<0.2) = 0;
trimap(trimap>0.2 & trimap<0.8) = 0.5;

if size(img,3) == 3
    img = rgb2gray(img);
end

% set parameters for iterations, you can change
maxIters = 1;

% TODO: initialize F and B, both are gray-scale image according to paper
% for 'definite foreground' pixels, F is value of img, B is zeros. 
% for 'definite background' pixels, B is value of img, F is zeros. 
% for 'undecided' pixels, F is the color of its nearest 'definite foreground' pixel
% for 'undecided' pixels, B is the color of its nearest 'definite background' pixel
[F,B] = find_nearestFB( trimap, img );

% calculate F-B
F_B = F-B;

% TODO: apply gaussian filter to F_B

%%# Read an image
F_B = imgaussfilt(F_B, 2);
% initialize alpha
alpha = trimap;

% iteratively solving
for i = 1:maxIters
    % TODO: solve for undecided regions using poission equation
    mask_undecided 	= (trimap==0.5); % mask for all undecide pixels
    alpha   		= poisson_equ( img, F_B, trimap );
    
    % TODO: update F and B
    
    trimap(alpha > 0.95) = 1;
    trimap(alpha < 0.05) = 0;
    [F,B] = find_nearestFB( trimap, img );
    F_B = F - B;
    % TODO: apply gaussian filter to F_B
    F_B = imgaussfilt(F_B, 2);
end

addpath('../');
white = ones(size(img, 1), size(img, 2), 3);
mattImg = matt(alpha, oriImg, white);
imshow(mattImg);