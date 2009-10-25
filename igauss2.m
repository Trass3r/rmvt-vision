%IGAUSS	Gaussian smoothing kernel
%
%	M = IGAUSS(IM, xc, yc, sigma)
%
%	Copyright (c) Peter Corke, 1999  Machine Vision Toolbox for Matlab

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

function m = igauss2(im, xc, yc, sigma)

	d = size(im);
	[x,y] = meshgrid(1:d(2), 1:d(1));

	x = x / d(2);
	y = y / d(1);
	m = 1/(2*pi) * exp( -((x-xc).^2 + (y-yc).^2)/2/sigma^2);

	m = m / sum(sum(m));

