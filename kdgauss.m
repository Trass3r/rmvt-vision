%GAUSS	Gaussian differential kernel
%
%	M = DGAUSS(SIGMA)
%	M = DGAUSS(SIGMA, W)
%
%	Returns a unit volume Gaussian differential function of standard deviation 
%	SIGMA.  The Gaussian is centered within the matrix whose half size
%	is W, that is, M is (2W+1) x (2W+1).
%
%	If W is not specified it defaults to 2*SIGMA.
%
% SEE ALSO:	gauss ilog conv2
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

function m = dgauss(sigma, w)


	if nargin == 1,
		w = ceil(3*sigma);
	end
	ww = 2*w + 1;

	[x,y] = meshgrid(-w:w, -w:w);

	m = -x/sigma^2 /(2*pi) .*  exp( -(x.^2 + y.^2)/2/sigma^2);

	%m = m / sum(sum(m));

