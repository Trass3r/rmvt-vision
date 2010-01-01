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
%	hp.k = 0.04;		Harris parameter
%	hp.cmin = 0;		Minimum corner strength
%	hp.cMinThresh = 0.01;	Minimum relative corner strength
%	hp.deriv = [-1 0 1; -1 0 1; -1 0 1] / 3;
%	hp.sigma = 1;		Standard dev. for the smoothing step
%	hp.edgegap = 2;		Corners this close to the border are ignored
%	hp.nfeat = Inf;		Maximum number of features to return
%	hp.harris = 1;		1 for Harris, 0 for inverse Noble detector
%	hp.tiling = 0;		if set to N, evaluate corners in NxN tiles
%	hp.distance = 0;		minimum distance between features
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


classdef iharris < FeatureList

    methods

        % constructor
        function h = iharris(im, varargin)

            % parse options into parameter struct
            p.k = 0.04;
            p.deriv = kdgauss(2);
            p.distance = 0;
            p.noble = false;

            p.cmin = 0;
            p.cMinThresh = 0.0;
            p.edgegap = 2;
            p.nfeat = 100;
            p.sigma_i = 2;
            p.verbose = false;

            argc = 1;
            while argc <= length(varargin)
                switch lower(varargin{argc})
                case 'k'
                    p.k = varargin{argc+1}; argc = argc+1;
                case 'deriv'
                    p.deriv = varargin{argc+1}; argc = argc+1;
                case 'nfeat'
                    p.nfeat = varargin{argc+1}; argc = argc+1;
                case 'cminthresh'
                    p.cMinThresh = varargin{argc+1}; argc = argc+1;
                case 'sigma_i'
                    p.sigma_i = varargin{argc+1}; argc = argc+1;
                case 'distance'
                    p.distance = varargin{argc+1}; argc = argc+1;
                case 'noble'
                    p.noble = true;
                case 'harris'
                    p.noble = false;
                case 'verbose'
                    p.verbose = true;

                otherwise
                    error( sprintf('unknown option <%s>', varargin{argc}));
                end
                argc = argc + 1;
            end

            if p.verbose
                fprintf('Harris parameter settings\n');
                p
            end


            if ndims(im) == 3,
                R = double(im(:,:,1));
                G = double(im(:,:,2));
                B = double(im(:,:,3));
                Rx = conv2(R, p.deriv, 'same');
                Ry = conv2(R, p.deriv', 'same');
                Gx = conv2(G, p.deriv, 'same');
                Gy = conv2(G, p.deriv', 'same');
                Bx = conv2(B, p.deriv, 'same');
                By = conv2(B, p.deriv', 'same');

                Ix = Rx.^2+Gx.^2+Bx.^2;
                Iy = Ry.^2+Gy.^2+By.^2;
                Ixy = Rx.*Ry+Gx.*Gy+Bx.*By;
            else
                % compute horizontal and vertical gradients
                ix = conv2(im, p.deriv, 'same');
                iy = conv2(im, p.deriv', 'same');
                Ix = ix.*ix;
                Iy = iy.*iy;
                Ixy = ix.*iy;
            end

            % smooth them
            if p.sigma_i > 0,
                Ix = ismooth(Ix, p.sigma_i);
                Iy = ismooth(Iy, p.sigma_i);
                Ixy = ismooth(Ixy, p.sigma_i);
            end


            % computer cornerness
            if p.noble,
                rawc = (Ix .* Iy - Ixy.^2) ./ (Ix + Iy);
            else
                rawc = (Ix .* Iy - Ixy.^2) - p.k * (Ix + Iy).^2;
            end

            % compute maximum value around each pixel
            cmax = imorph(rawc, [1 1 1;1 0 1;1 1 1], 'max');

            % if pixel exceeds this, its a local maxima, find index
            cindex = find(rawc > cmax);

            % remove those near edges
            [nr,nc] = size(Ix);
            [y, x] = ind2sub(size(rawc), cindex);
            e = p.edgegap;
            sel = (x>e) & (y>e) & (x < (nc-e)) & (y < (nr-e));
            cindex = cindex(sel);

            p.npix = nr*nc;

            fprintf('%d corners found (%.1f%%), ', length(cindex), ...
                length(cindex)/p.npix*100);
            N = min(length(cindex), p.nfeat);

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
                if c < p.cmin,
                    break;
                end

                % 2. corner strength must exceed a fraction of the maximum value
                if c/cmax < p.cMinThresh,
                    break;
                end

                % get the coordinate
                [y, x] = ind2sub(size(rawc), K);

                % enforce separation between corners
                % TODO: strategy of Brown etal. only keep if 10% greater than all within radius
                if (p.distance > 0) && (i>1)
                    d = sqrt( ([h.y]'-y).^2 + ([h.x]'-x).^2 );
                    if min(d) < p.distance,
                        continue;
                    end
                end

                % ok, this one is for keeping
                h.x(fc) = x;
                h.y(fc) = y;
                h.strength(fc) = c;
                h.descriptor(fc,:) = [Ix(K) Iy(K) Ixy(K)];
                fc = fc + 1;

                % terminate if we have enough features
                if fc > N,
                    break;
                end
            end
            fprintf(' %d corner features saved\n', fc-1);
            f.image = im;
            h.corner_image = rawc;
        end     % Harris



        function m = match(f1, f2)

            m = matchobj;

            m.image1 = f1.image;
            m.image2 = f2.image;

            [matches,d] = siftmatch(f1.descriptor, f2.descriptor);

            % build the vector of matching coordinates
            m.xy = zeros(numcols(matches), 4);
            for i=1:numrows(m.xy),
                k1 = matches(1,i);
                k2 = matches(2,i);
                m.xy(i,:) = [f1.x(k1) f1.y(k1) f2.x(k2) f2.y(k2)];
            end
            m.strength = d';
        end

    end
end

