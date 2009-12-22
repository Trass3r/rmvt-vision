%IDECIMATE	Decimate an image
%
%	s = idecimate(im, m)
%	s = shrink(im, m, sigma)
%	s = shrink(im, m, [])
%
%   Reduce the image by a factor of M in each direction.  M is an integer.
%	Smooth the image, IM, using Gaussian
%	smoothing of SIGMA (default 1) and then subsample by a factor of
%	N (default 2) in both directions.  
%
% SEE ALSO:	kgauss
%

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

function s = shrink(im, m, sigma)

    if nargin < 2
        m = 2;
    end

    if (m - ceil(m)) ~= 0
        error('decimation factor must be integer');
    end

    if nargin < 3
        sigma = m / 2;
    end

    % smooth the image
    if ~isempty(sigma)
        im = ismooth(im, sigma);
    end

    % then decimate
	s = im(1:m:end,1:m:end,:);
