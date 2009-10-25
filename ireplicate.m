%IREPLICATE  Expand an image by pixel replication
%
%   out = ireplicate(im)
%
%   Return an image with twice the number of pixels in each dimension, pixels
%   are replicated in 2x2 blocks.
%
%   out = ireplicate(im, M)
%
%   Perform M replications.

function ir2 = ireplicate(im, M)

    if size(im, 3) > 1
        error('color images not supported');
    end

    if nargin < 2
        M = 1;
    end

    dims = size(im);
    nr = dims(1); nc = dims(2);

    % replicate the columns
    ir = zeros(M*nr,nc);
    for i=1:M
        ir(i:M:end,:) = im;
    end

    % replicate the rows
    ir2 = zeros(M*nr,M*nc);
    for i=1:M
        ir2(:,i:M:end) = ir;
    end

