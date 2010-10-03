%ISCALE scale and rotate an image
%
%  out = iscale(im, factor)
%       Returns an image that is larger or smaller than the input image
%       according to the scale factor. >1 is larger, <1 is smaller.
%
%  out = iscale(im, factor, angle)
%       Returns an image of the same size as the input image that has been
%       scaled and rotated about its centre.  Rotation is defined with 
%       respect to a z-axis into the image. Counter-clockwise is a
%       positive angle.

function im2 = iscale(im, factor, varargin)

    outsize = [];
    bgcolor = 0;
    
    opt.outsize = [];
    opt.extrapval = 0;

    opt = tb_optparse(opt, varargin);
    
    if isfloat(im)
        is_int = false;
    else
        is_int = true;
        im = idouble(im);
    end
    im = ismooth(im, 1);

    [nr,nc,np] = size(im);

    if isempty(opt.outsize)
        ncs = nc;
        nrs = nr;
    else
        % else from specified size
    % output image size is determined by input size and scale factor
        nrs = floor(nr*factor);
        ncs = floor(nc*factor);
    end


    % create the coordinate matrices for warping
    [U,V] = imeshgrid(im);
    [Up,Vp] = imeshgrid(nrs, ncs);


    Up = Up/factor;
    Vp = Vp/factor;

    
    for k=1:size(im,3)
        im2(:,:,k) = interp2(U, V, im(:,:,k), Up, Vp, 'linear', opt.extrapval);
    end

    if is_int
        im2 = iint(im2);
    end
