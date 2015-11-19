function res = poisson_equ( img, F_B, trimap )
% Input:
%   - img: input color image
%   - F_B: F-B image
%   - mask: mask=1 for all undecided pixels
% Output:
%   - res: result of alpha 
    src     = img./(F_B);
    trg     = trimap;
    %% Poisson Equation
    mask = double(trimap==0.5);     % undecided regions
    h   = fspecial('laplacian', 0);
    chi = imfilter(double(mask),h);
    chi(chi<0) = 0;
    chi(chi>0) = 1;

    % Error
    erf = trg - src;

    a = erf;
    a(~chi) =  0;

    % Laplace eq. with Dirichlet bc 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Ierf = LaplacianDirichlet(a,mask);
    temp = Ierf + src;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    trg(mask) = temp(mask);
    res = trg;
end

function [ out ] = LaplacianDirichlet(rhs, mask)
    I = rhs;
    [r,c] = size(I);
    k = r*c;

    %% Matrix Construction

    % Ones for columns and rows
    dy = ones(size(I,1)-1, size(I,2));
    dy = padarray(dy, [1 0], 'post');
    dy = dy(:);

    dx = ones(size(I,1), size(I,2)-1);
    dx = padarray(dx, [0 1], 'post');
    dx = dx(:);


    % Construct five-point spatially homogeneous Laplacian matrix
    C(:,1) = dx;
    C(:,2) = dy;
    d = [-r,-1];
    A = spdiags(C,d,k,k);

    e = dx;
    w = padarray(dx, r, 'pre'); w = w(1:end-r);
    s = dy;
    n = padarray(dy, 1, 'pre'); n = n(1:end-1);

    % D = -(e+w+s+n);
    D = ((e+w+s+n)) .* mask(:) + (1-mask(:));
    L = -(A + A');
    m = find(~mask);
    L(m,:) = 0;
    L = L+spdiags(D, 0, k, k);

    % Solve
    out = L\I(:);
    out = reshape(out, r, c);

    % Sanitiy check
    % out2 = L*out(:);
    % out2 = reshape(out2, r, c);
end