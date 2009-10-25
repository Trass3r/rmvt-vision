function im2 = shrink(im, factor)

    im = conv2( im, kgauss(1), 'same');
    [nr,nc] = size(im);
    nrs = floor(nr*factor);
    ncs = floor(nc*factor);

    [X,Y] = meshgrid(1:nc, 1:nr);
    [Xi,Yi] = meshgrid(1:ncs, 1:nrs);

    im2 = interp2(X, Y, im, Xi/factor, Yi/factor);
