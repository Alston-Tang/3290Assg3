function [ alpha ] = triangulationmatt( img1,img2 )
	%BB1   = img1(1,1,3);
	%BB2   = img2(1,1,3);
    
    BB1 = 1;
    BB2 = 0.5;
    
    B1 = img1(:,:,3);
    B2 = img2(:,:,3);
    
    alpha = 1 - (B1 - B2) ./ (BB1 - BB2);

end

