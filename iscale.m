% rotation is defined with respect to a z-axis into the image.
% CW is a positive angle
function im2 = iscale(im, factor, angle, outsize, bgcolor)

    if isfloat(im)
        is_int = false;
    else
        is_int = true;
        im = idouble(im);
    end
    im = ismooth(im, 1);

    [nr,nc,np] = size(im);
    if nargin < 4
        % output image size is determined by input size and scale factor
        nrs = floor(nr*factor);
        ncs = floor(nc*factor);
    else
        if isempty(outsize)
            ncs = nc;
            nrs = nr;
        else
            % else from specified size
            ncs = outsize(1);
            nrs = outsize(2);
        end
    end
    if nargin < 5
        bgcolor = 0;
    end

    % create the coordinate matrices for warping
    [U,V] = imeshgrid(im);
    [Up,Vp] = imeshgrid(nrs, ncs);

    if nargin < 3
        % no rotation, just scale
        Up = Up/factor;
        Vp = Vp/factor;
    else
        % rotation and scale
        R = rotz(angle);
        uc = nc/2; vc = nr/2;
        Vp = R(2,1)*(Up-uc)+R(2,2)*(Vp-vc)+uc;
        Up = R(1,1)*(Up-uc)+R(1,2)*(Vp-vc)+vc;
    end

    for k=1:size(im,3)
        im2(:,:,k) = interp2(U, V, im(:,:,k), Up, Vp, 'linear', bgcolor);
    end

    if is_int
        im2 = iint(im2);
    end
