%IDECIMATE	Decimate an image
%
%	s = idecimate(im, M)
%	s = shrink(im, M, sigma)
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

function s = shrink(im, M, sigma)

    if nargin < 2
        M = 2;
    end

    if (M - ceil(M)) ~= 0
        error('decimation factor must be integer');
    end

    if nargin < 3
        sigma = M / 2;
    end

    % smooth the image
	im = ismooth(im, sigma);

    % then decimate
	s = im(1:M:end,1:M:end);
