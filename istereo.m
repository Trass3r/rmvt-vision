%STEREO Stereo matching
%
%   [disp,sim] = stereo(L, R, w, range)
%   [disp,sim] = stereo(L, R, w, range, metric)
%   
% Where L and R are the left- and right-images of a stereo pair, of either
% double or uint8 class.
%
% w is the size of the matching window, which can we a scalar for wxw or a
% 2-vector [wx wy] for a wx x wy window.
%
% range is the disparity search range, which can be a scalar for disparities in
% the range 0 to range, or a 2-vector [dmin dmax] for searches in the range
% dmin to dmax.
%
% metric is a string that specififies the similarity metric to use and can be
% one of 'zncc' (default), 'ncc', 'ssd' or 'sad'.
%
% disp and sim are both images of the same size as L and R.
% The value of disp(i,j) is the disparity for pixel L(i,j).
% The value of sim(i,j) is the similarity score corresponding to the disparity.
%
% For both output images the pixels within a half-window dimension of the edges 
% will not be valid and are set to NaN.
%
%   [disp,sim] = stereo(L, R, w, range, metric, interp)
%
% if interp is non-zero then the disparity image, disp, will be interpolated
% to fraction pixels.


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
function [disp,sim, x] = stereo(L, R, drange, h, varargin)

    opt.metric = 'zncc';
    opt.interp = false;

    opt = tb_optparse(opt, varargin);

    % ensure images are greyscale
    L = imono(L);
    R = imono(R);

    if length(drange) > 2
        vshift = drange(3);
        if vshift > 0
            L = L(vshift:end,:);
            R = R(1:end-vshift,:);
        else
            vshift = -vshift;
            L = L(1:end-vshift,:);
            R = R(vshift:end,:);
        end
    end
    % compute the score cube, 3rd dimension is disparity
    scores = stereo_match(L, R, 2*h+1, drange(1:2), opt.metric);

    % best value along disparity dimension is the peak
    %   s best score
    %   d disparity at which it occurs
    %
    % both s and d are matrices same size as L and R.
    if strcmp(opt.metric, 'sad') | strcmp(opt.metric, 'ssd')
        [s,d] = min(scores, [], 3);
    else
        [s,d] = max(scores, [], 3);
    end

    d = d + drange(1)-1;

    if opt.interp
        % interpolated result required

        % get number of pixels and disparity range
        npix = prod(size(L));

        if length(drange) == 1,
            ndisp = drange + 1;
        else
            dmin = min(drange);
            dmax = max(drange);
            ndisp = dmax - dmin + 1;
        end

        % find all disparities that are not at either end of the range, we need
        % a point on either side to interpolate them
        valid = (d>1) & (d<ndisp);
        valid = valid(:);

        % make a vector of consecutive pixel indices (1 to width*height)
        ci = [1:npix]';
        % turn disparities into a column vector
        dcol = d(:);

        % remove all entries that are not valid
        ci(~valid) = [];
        dcol(~valid) = [];

        % both ci and dcol have the same number of entries

        % for every valid pixel and disparity, find the index into the 3D score
        % array.  We cheat and consider that array WxHxD as a 2D array (WxH)xD
        %
        % We compute the indices for the best score and one each side of it
        k_m = sub2ind([npix ndisp], ci, dcol-1);
        k_0 = sub2ind([npix ndisp], ci, dcol);
        k_p = sub2ind([npix ndisp], ci, dcol+1);

        % initialize matrices (size of L and R) to hold the the best score
        % and the one each side of it
        y_m = ones(size(L))*NaN;
        y_0 = ones(size(L))*NaN;
        y_p = ones(size(L))*NaN;

        % now copy over the valid scores into these arrays.  What doesnt
        % get copies is a NaN
        y_m(ci) = scores(k_m);
        y_0(ci) = scores(k_0);
        y_p(ci) = scores(k_p);

        % figure the coefficients of the peak fitting parabola:
        %    y = Ax^2 + Bx + C
        % Each coefficient is a matrix same size as (L and R)
        % We don't need to compute C
        A = 0.5*y_m - y_0 + 0.5*y_p;
        B = -0.5*y_m + 0.5*y_p;

        % now the position of the peak is given by -B/2A
        dx = -B ./ (2*A);

        % and we add this fractional part to the integer value obtained
        % from the max/min function
        d = d + dx;

   end

    if nargout > 1,
        sim = s;
    end
    if nargout > 0,
        disp = d;
    end

    if opt.interp && nargout == 3,
        x.A = A;
        x.B = B;
        x.dx = dx;
    end
