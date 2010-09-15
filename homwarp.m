%HOMWARP  Warp image according to homography
%
%  out = homwarp(H, image, opts)
%
%  Apply the homography H to pixel coordinates in the input image.
%
% 'full'             output image contains the full input image
% 'extrapval', val   set not mapped pixels to this value
% 'box', roi         output image contains the specified ROI in the input image
% 'scale', s         scale the output by this factor
% 'dimension', d     ensure output image is d x d
% 'size', sz(2)      size of output image
function [w,foffs] = homwarp(H, im, varargin)

    opt.full = false;
    opt.extrapval = NaN;
    opt.size = [];
    opt.box = [];
    opt.scale = 1;
    opt.dimension = [];

    opt = tb_optparse(opt, varargin);

    if isempty(opt.box) && ~opt.full
        error('must specify box or full size');
    end

    [w,h] = isize(im);

    if opt.full
        % bounding box in the input image is the full extent
        box = [1 w w 1; 1 1 h h];
    else
        % opt.box is specified in standard ROI format
        l = opt.box(1,1); t = opt.box(2,1);
        r = opt.box(1,2); b = opt.box(2,2);
        box = [l r r l; t t b b];
    end

    % map the box vertices in input image to vertices in output image
    Hbox = homtrans(H, box);

    % determine the extent
    xmin = min(Hbox(1,:)); xmax = max(Hbox(1,:));
    ymin = min(Hbox(2,:)); ymax = max(Hbox(2,:));

    % we want the pixel coordinates to map to positive values, determine the minimum
    offs = floor([xmin, ymin]);

    % and prepend a translational homography that translates the output image
    H = [1 0 -offs(1); 0 1 -offs(2); 0 0 1] * H;
    sz = round([xmax-xmin+1, ymax-ymin+1]);

    if ~isempty(opt.dimension)
        s = opt.dimension / max(sz);
        H = diag([s s 1]) * H;

        Hbox = homtrans(H, box);

        % determine the extent
        xmin = min(Hbox(1,:)); xmax = max(Hbox(1,:));
        ymin = min(Hbox(2,:)); ymax = max(Hbox(2,:));

        % we want the pixel coordinates to map to positive values, determine the minimum
        offs = floor([xmin, ymin]);

        % and prepend a translational homography that translates the output image
        H = [1 0 -offs(1); 0 1 -offs(2); 0 0 1] * H;
        sz = round([xmax-xmin+1, ymax-ymin+1]);
    end
    
    [Ui,Vi] = imeshgrid(im);

    % determine size of the output image
    if isempty(opt.size)
        [Uo,Vo] = imeshgrid(sz);
    else
        [Uo,Vo] = imeshgrid(opt.size);
    end
            
    UV = homtrans(inv(H), [Uo(:) Vo(:)]');
    U = reshape(UV(1,:), size(Uo));
    V = reshape(UV(2,:), size(Vo));

    % warp each color plane
    for p=1:size(im,3)
        imh(:,:,p) = interp2(Ui, Vi, idouble(im(:,:,p)), U, V, 'linear', opt.extrapval);
    end

    if nargout > 0
        w = imh;
    else
        idisp(imh);
    end

    if nargout > 1 && opt.full
        foffs = offs;
    end
