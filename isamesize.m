function im2 = ifit(im, im1, bias)
    % return im scaled/cropped to be the same size as im1

    if nargin < 3
        bias = 0.5;
    end

    if bias < 0 || bias > 1
        error('bias must be in the range [0,1]')
    end
    sz1 = size(im1);
    sz = size(im);
    scale = sz1(1:2) ./ sz(1:2);

    scale
    im2 = iscale(im, max(scale));

    if numrows(im2) > numrows(im1)
        % scaled image is too high, trim some rows
        d = numrows(im2) - numrows(im1);
        d1 = max(1, floor(d*bias));
        d2 = d-d1;
        [1 d d1 d2]
        im2 = im2(d1:end-d2-1,:,:);
    end
    if numcols(im2) > numcols(im1)
        % scaled image is too wide, trim some columns
        d = numcols(im2) - numcols(im1);
        d1 = max(1, floor(d*bias));
        d2 = d-d1;
        [2 d d1 d2]
        im2 = im2(:,d1:end-d2-1,:);
    end
