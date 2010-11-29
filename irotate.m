%IROTATE rotate image
%
%  out = iscale(im, factor, angle)
%       Returns an image of the same size as the input image or smaller.
%   that has been
%       scaled and rotated about its centre.  Rotation is defined with 
%       respect to a z-axis into the image. Counter-clockwise is a
%       positive angle. factor >1 is larger, <1 is smaller.

function im2 = irotate(im, angle, varargin)

    opt.outsize = [];
    opt.crop = false;
    opt.scale = 1.0;
    opt.extrapval = 0;
    
    opt = tb_optparse(opt, varargin);

    if isfloat(im)
        is_int = false;
    else
        is_int = true;
        im = idouble(im);
    end
    %im = ismooth(im, 1);

    [nr,nc,np] = size(im);

    if isempty(opt.outsize)
        % output image size is determined by input size 
        [Uo,Vo] = imeshgrid(im);

    else
        % else from specified size
        [Uo,Vo] = meshgrid(1:outsize(1), 1:outsize(2));
    end



    % create the coordinate matrices for warping
    [Ui,Vi] = imeshgrid(im);


    % rotation and scale
    R = rotz(angle);
    uc = nc/2; vc = nr/2;
    Uo2 = 1/opt.scale*(R(1,1)*(Uo-uc)+R(2,1)*(Vo-vc))+uc;
    Vo2 = 1/opt.scale*(R(1,2)*(Uo-uc)+R(2,2)*(Vo-vc))+vc;

    Uo = Uo2;
    Vo = Vo2;

    
    if opt.crop
        trimx = abs(nr/2*sin(angle));
        trimy = abs(nc/2*sin(angle));
        if opt.scale < 1
            trimx = trimx + nc/2*(1-opt.scale);
            trimy = trimy + nr/2*(1-opt.scale);
        end
        trimx = ceil(trimx) + 1;
        trimy = ceil(trimy) + 1;
        trimx
        trimy
        Uo = Uo(trimy:end-trimy,trimx:end-trimx);
        Vo = Vo(trimy:end-trimy,trimx:end-trimx);

    end

    for k=1:size(im,3)
        im2(:,:,k) = interp2(Ui, Vi, im(:,:,k), Uo, Vo, 'linear', opt.extrapval);
    end

    if is_int
        im2 = iint(im2);
    end
