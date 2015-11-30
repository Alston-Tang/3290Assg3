function [ resImg ] = matt(alpha, fImg, bImg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%fImg = double(fImg) / 255;
%bImg = double(bImg) / 255;

fR = fImg(:,:,1);
fG = fImg(:,:,2);
fB = fImg(:,:,3);

bR = bImg(:,:,1);
bG = bImg(:,:,2);
bB = bImg(:,:,3);

ba = 1 - alpha;

R = fR .* alpha + bR .* ba;
B = fB .* alpha + bB .* ba;
G = fG .* alpha + bG .* ba;

resImg = cat(3, R, G, B);

end

