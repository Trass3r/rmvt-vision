function im2 = iscale(im, factor, angle)

    if isfloat(im)
        is_int = false;
    else
        is_int = true;
        im = idouble(im);
    end
    im = ismooth(im, 1);

    [nr,nc,np] = size(im);
    nrs = floor(nr*factor);
    ncs = floor(nc*factor);

    [X,Y] = imeshgrid(im);
    [Xi,Yi] = imeshgrid(nrs, ncs);

    for k=1:size(im,3)
        im2(:,:,k) = interp2(X, Y, im(:,:,k), Xi/factor, Yi/factor);
    end

    if is_int
        im2 = iint(im2);
    end
        
