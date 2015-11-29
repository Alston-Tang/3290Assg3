function [F, B, alpha] = bayesian_matting(img, trimap)
% Put your code here
% Intialize alpha
import java.util.LinkedList;

C = double(img);
trimap = double(trimap);
alpha = trimap ./ 255;
alpha(alpha < 0.1) = 0;
alpha(alpha > 0.9) = 1;
alpha(alpha >= 0.1 & alpha <= 0.9) = 0.5;
decided = zeros(size(img, 1), size(img, 2));
decided(trimap == 255 | trimap == 0) = 1;
inQ = decided;
bQ = getBoundary(img, trimap, 128, inQ);

nSize = 5;
NSize = 23;
mid = (NSize + 1) / 2;
sigma = 5;
sigmaC = 8;

G = zeros(NSize, NSize);
for i = 1 : NSize
    for j = 1 : NSize
        G(i, j) = exp(-((mid-i)^2 + (mid-j)^2) / sigma);
    end
end

while ~bQ.isEmpty()
    disp(bQ.size());
    %Initilize alpha
    p = bQ.remove();
    pY= p(1);
    pX = p(2);
    extend = (nSize - 1) / 2;
    t = pY - extend;
    b = pY + extend;
    l = pX - extend;
    r = pX + extend;
    if t < 1 t = 1; end
    if b > size(img, 1) b = size(img, 1); end
    if l < 1 l = 1; end
    if r > size(img, 2) r = size(img, 2); end
    maskAlpha = decided(t : b, l : r) .* alpha(t : b, l : r);
    pAlpha = sum(sum(maskAlpha)) / sum(sum(decided(t : b, l : r)));
    
    %Calculate F
    extend = (NSize - 1) / 2;
    NWindowAlpha = zeros(NSize, NSize);
    t = pY - extend;
    b = pY + extend;
    l = pX - extend;
    r = pX + extend;
    if t < 1 t = 1; end
    if b > size(img, 1) b = size(img, 1); end
    if l < 1 l = 1; end
    if r > size(img, 2) r = size(img, 2); end
    NWindowAlpha(mid-pY+t:mid-pY+b,mid-pX+l:mid-pX+r) = alpha(t : b, l : r);
    NWindow  = NWindowAlpha .^ 2 .* G;
    W = sum(sum(NWindow));
    CWindow = zeros(NSize, NSize);
    CWindow(mid-pY+t:mid-pY+b, mid-pX+l:mid-pX+r) = C(t : b, l : r);
    dashF = sum(sum(NWindow .* CWindow)) ./ W;
    sumF = sum(sum(NWindow .* ((CWindow - dashF) .^ 2))) / W;
    
    %Calculate B
    NWindowAlpha = 1 - NWindowAlpha;
    NWindow = NWindowAlpha .^ 2 .* G;
    W = sum(sum(NWindow));
    dashB = sum(sum(NWindow .* CWindow)) / W;
    sumB = sum(sum(NWindow .* ((CWindow - dashB) .^ 2))) / W;
    
    %Given alpha calc F,B
    
    pC = [C(pY, pX, 1), C(pY, pX, 2), C(pY, pX, 3)];
    lu = sumF^-1 + eye(3) * pAlpha^2 / sigmaC^2;
    lb = eye(3) * pAlpha * (1-pAlpha) / sigmaC^2;
    ru = lb;
    rb = sumB^-1 + eye(3) * (1-pAlpha)^2 / sigmaC^2;
    LHS(1:3,1:3) = lu;
    LHS(4:6,1:3) = lb;
    LHS(1:3,4:6) = ru;
    LHS(4:6,4:6) = rb;
    
    lu = sumF^-1*dashF + pC * pAlpha / sigmaC^2;
    lb = sumB^-1*dashB + pC * (1-pAlpha) / sigmaC^2;
    RHS(1:3,1) = lu;
    RHS(4:6,1) = lb;
    res = LHS \ RHS;
    F = res(1:3);
    B = res(4:6);
    alpha(pY, pX) = dot(transpose(pC) - B, F - B) / sum((F-B) .^ 2);
    %Update Queue
    decided(pY, pX) = 1;
    for i = -1:2:1
        for j = -1:2:1
            nY = pY + i;
            nX = pX + j;
            if nY >= 1 && nY <=size(C, 1) && nX >= 1 && nX <= size(C, 2)
                if ~inQ(nY, nX)
                    bQ.add([nY, nX]);
                    inQ(nY, nX) = 1;
                end
            end
        end
    end
end


% Fix alpha solve F,B
% Fix F,B solve alphs
end