%IHARRIS		Harris corner detector
%
%	hp = iharris
%	F = iharris(im)
%	F = iharris(im, hp)
%	[F,C] = iharris(im, hp)
%
%	The return value is a vector of structures, each with the elements:
%		F.x	x-coordinate of feature
%		F.y	y-coordinate of feature
%		F.Ix	the smoothed x-gradient at the point
%		F.Iy	the smoothed y-gradient at the point
%		F.Ixy	the smoothed xy-gradient at the point
%		F.c	corner strength at the point
%
%  C is the cornerness image corresponding to im.
%
% The corners are processed in order from strongest to weakest.  The function
% stops when:
%	- the corner strength drops below P.cmin
%	- the corner strenght drops below P.cMinThresh * strongest corner
%	- the list of corners is exhausted
%
% PARAMETERS:
%
% This function has a number of parameters which are combined into a single
% structure (default values shown):
%
%	hopt.k = 0.04;		Harris parameter
%	hopt.cmin = 0;		Minimum corner strength
%	hopt.cMinThresh = 0.01;	Minimum relative corner strength
%	hopt.deriv = [-1 0 1; -1 0 1; -1 0 1] / 3;
%	hopt.sigma = 1;		Standard dev. for the smoothing step
%	hopt.edgegap = 2;		Corners this close to the border are ignored
%	hopt.nfeat = Inf;		Maximum number of features to return
%	hopt.harris = 1;		1 for Harris, 0 for inverse Noble detector
%	hopt.tiling = 0;		if set to N, evaluate corners in NxN tiles
%	hopt.distance = 0;		minimum distance between features
%
% The default parameter setting can be obtained with a call of the form:
%		P = iharris
%
% Passing in P will override those elements provided.
%
% In order to have good spatial layout of features set for example:
%
%	P.nfeat = 20;
%	P.tiling = 3;
%
% which will place 20 features in each of 9 tiles that cover the image in
% a 3x3 pattern.
%
%
% REF:	"A combined corner and edge detector", C.G. Harris and M.J. Stephens
%	Proc. Fourth Alvey Vision Conf., Manchester, pp 147-151, 1988.
%
% SEE ALSO:	showcorners

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.


function [features, corner_strength] = iharris(im, varargin)

    % parse options into parameter struct
    opt.k = 0.04;
    opt.deriv = kdgauss(2);
    opt.distance = 0;
    opt.detector = 'harris';

    opt.cmin = 0;
    opt.cMinThresh = 0.0;
    opt.edgegap = 2;
    opt.nfeat = 100;
    opt.sigma_i = 2;
    opt.verbose = false;

    argc = 1;
    while argc <= length(varargin)
        switch lower(varargin{argc})
        case 'k'
            opt.k = varargin{argc+1}; argc = argc+1;
        case 'deriv'
            opt.deriv = varargin{argc+1}; argc = argc+1;
        case 'nfeat'
            opt.nfeat = varargin{argc+1}; argc = argc+1;
        case 'cminthresh'
            opt.cMinThresh = varargin{argc+1}; argc = argc+1;
        case 'sigma_i'
            opt.sigma_i = varargin{argc+1}; argc = argc+1;
        case 'distance'
            opt.distance = varargin{argc+1}; argc = argc+1;
        case 'noble'
            opt.detector = 'noble';
        case 'klt'
            opt.detector = 'klt';
        case 'verbose'
            opt.verbose = true;

        otherwise
            error( sprintf('unknown option <%s>', varargin{argc}));
        end
        argc = argc + 1;
    end

    if opt.verbose
        fprintf('Harris parameter settings\n');
        p
    end


    if ndims(im) == 3,
        R = double(im(:,:,1));
        G = double(im(:,:,2));
        B = double(im(:,:,3));
        Rx = conv2(R, opt.deriv, 'same');
        Ry = conv2(R, opt.deriv', 'same');
        Gx = conv2(G, opt.deriv, 'same');
        Gy = conv2(G, opt.deriv', 'same');
        Bx = conv2(B, opt.deriv, 'same');
        By = conv2(B, opt.deriv', 'same');

        Ix = Rx.^2+Gx.^2+Bx.^2;
        Iy = Ry.^2+Gy.^2+By.^2;
        Ixy = Rx.*Ry+Gx.*Gy+Bx.*By;
    else
        % compute horizontal and vertical gradients
        ix = conv2(im, opt.deriv, 'same');
        iy = conv2(im, opt.deriv', 'same');
        Ix = ix.*ix;
        Iy = iy.*iy;
        Ixy = ix.*iy;
    end

    % smooth them
    if opt.sigma_i > 0,
        Ix = ismooth(Ix, opt.sigma_i);
        Iy = ismooth(Iy, opt.sigma_i);
        Ixy = ismooth(Ixy, opt.sigma_i);
    end

    [nr,nc] = size(Ix);
    npix = nr*nc;

    % computer cornerness
    if strcmp(opt.detector, 'harris')
        rawc = (Ix .* Iy - Ixy.^2) - opt.k * (Ix + Iy).^2;
    elseif strcmp(opt.detector, 'noble')
        rawc = (Ix .* Iy - Ixy.^2) ./ (Ix + Iy);
    elseif strcmp(opt.detector, 'klt')
        rawc = zeros(size(Ix));
        for i=1:npix
            lambda = eig([Ix(i) Ixy(i); Ixy(i) Iy(i)]);
            rawc(i) = min(lambda);
        end
    end

    % compute maximum value around each pixel
    cmax = imorph(rawc, [1 1 1;1 0 1;1 1 1], 'max');

    % if pixel exceeds this, its a local maxima, find index
    cindex = find(rawc > cmax);

    % remove those near edges


    [y, x] = ind2sub(size(rawc), cindex);
    e = opt.edgegap;
    sel = (x>e) & (y>e) & (x < (nc-e)) & (y < (nr-e));
    cindex = cindex(sel);


    fprintf('%d corners found (%.1f%%), ', length(cindex), ...
        length(cindex)/npix*100);
    N = min(length(cindex), opt.nfeat);

    % sort into descending order
    cval = rawc(cindex);		% extract corner values
    [z,k] = sort(-cval);	% sort into descending order
    cindex = cindex(k);
    cmax = rawc( cindex(1) );   % take the strongest feature value

    fc = 1;
    for i=1:length(cindex),
        K = cindex(i);
        c = rawc(K);

        % we apply two termination threshold conditions:

        % 1. corner strength must exceed an absolute minimum
        if c < opt.cmin
            break;
        end

        % 2. corner strength must exceed a fraction of the maximum value
        if c/cmax < opt.cMinThresh
            break;
        end

        % get the coordinate
        [y, x] = ind2sub(size(rawc), K);

        % enforce separation between corners
        % TODO: strategy of Brown etal. only keep if 10% greater than all within radius
        if (opt.distance > 0) && (i>1)
            d = sqrt( ([features.v]'-y).^2 + ([features.u]'-x).^2 );
            if min(d) < opt.distance,
                continue;
            end
        end

        % ok, this one is for keeping
        features(fc) = CornerFeature(x, y, c);
        features(fc).descriptor = [Ix(K) Iy(K) Ixy(K)]';
        fc = fc + 1;

        % terminate if we have enough features
        if fc > N,
            break;
        end
    end
    fprintf(' %d corner features saved\n', fc-1);

    % sort into descending order
    [z,k] = sort(-[features.strength]);
    features = features(k);

    if nargout > 1
        corner_strength = rawc;
    end
