function [alpha ] = noblue( img)
%% Implement no blue matting
	% the pixel at (1,1) is 'definite background' by observation
	% BB    = img(1,1,3);
    
    BB = 1;
    B = img(:,:,3);
    alpha = 1 - B ./ BB;

end


