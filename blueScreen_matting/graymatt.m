function [alpha ] = graymatt( img)
%% Implement no blue matting
	% the pixel at (1,1) is 'definite background' by observation
	% BB = img(1,1,3);
    
    BB = 1;
    B = img(:,:,3);
    G = img(:,:,2);
    alpha = 1 - (B - G) ./ BB;
end
%%


