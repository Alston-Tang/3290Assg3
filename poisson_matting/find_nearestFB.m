function [F_undecided,B_undecided] = find_nearestFB( trimap, img )
% Input:
% 	- trimap: where 1 indicates foreground, 0 indicates background, 0.5 for undecided
% 	- img: input color image
% Output:
% 	- F_undecided: an image of F for all undecided pixels.
% 	- B_undecided: an image of B for.................................000
% all undecided pixels.



fIndex = trimap == 1;
bIndex = trimap == 0;
uIndex = trimap == 0.5;

% TODO: separate img to foreground part and background part

F_undecided = zeros(size(img));
B_undecided = zeros(size(img));

F = img .* fIndex;
B = img .* bIndex;



% TODO: for each undecided pixel, search for its nearest neighbor in F

fBound = getBoundary(trimap, 1, 0.5);

while ~fBound.isEmpty()
    p = fBound.remove();
    h = p(1);
    w = p(2);
    if trimap(h, w) == 1
        v = img(h, w);
    else
        v = F_undecided(h, w);
    end
    if trimap(h - 1, w) == 0.5
        F_undecided(h-1, w) = v;
        trimap(h-1, w) = 0.4;
        fBound.add([h-1,w]);
    end
    if trimap(h + 1, w) == 0.5
        F_undecided(h+1, w) = v;
        trimap(h+1, w) = 0.4;
        fBound.add([h+1,w]);
    end
    if trimap(h, w - 1) == 0.5
        F_undecided(h, w-1) = v;
        trimap(h, w-1) = 0.4;
        fBound.add([h,w-1]);
    end
    if trimap(h, w + 1) == 0.5
        F_undecided(h, w+1) = v;
        trimap(h, w+1) = 0.4;
        fBound.add([h,w+1]);
    end
end


% TODO: for each undecided pixel, search for its nearest neighbor in B

bBound = getBoundary(trimap, 0, 0.4);
while ~bBound.isEmpty()
    p = bBound.remove();
    h = p(1);
    w = p(2);
    if trimap(h, w) == 0
        v = img(h, w);
    else
        v = B_undecided(h, w);
    end
    if trimap(h - 1, w) == 0.4
        B_undecided(h-1, w) = v;
        trimap(h-1, w) = 0.5;
        bBound.add([h-1,w]);
    end
    if trimap(h + 1, w) == 0.4
        B_undecided(h+1, w) = v;
        trimap(h+1, w) = 0.5;
        bBound.add([h+1,w]);
    end
    if trimap(h, w - 1) == 0.4
        B_undecided(h, w-1) = v;
        trimap(h, w-1) = 0.5;
        bBound.add([h,w-1]);
    end
    if trimap(h, w + 1) == 0.4
        B_undecided(h, w+1) = v;
        trimap(h, w+1) = 0.5;
        bBound.add([h,w+1]);
    end
end

F_undecided = F_undecided + F;
B_undecided = B_undecided + B; 


end