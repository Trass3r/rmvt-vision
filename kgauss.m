%KGAUSS	Gaussian smoothing kernel
%
%	k = kgauss(sigma)
%	k = kgauss(sigma, w)
%
%	Returns a unit volume Gaussian smoothing kernel.  The Gaussian has 
%	a standard deviation of sigma, and the convolution
%	kernel has a half size of w, that is, k is (2W+1) x (2W+1).
%
%	If w is not specified it defaults to 2*sigma.
%
% SEE ALSO:	ismooth conv2

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

function m = kgauss(sigma, w)


	if nargin == 1,
		w = ceil(3*sigma);
	end
	ww = 2*w + 1;

	[x,y] = meshgrid(-w:w, -w:w);

	m = 1/(2*pi*sigma^2) * exp( -(x.^2 + y.^2)/2/sigma^2);

    % area under the curve should be 1, but the discrete case is only
    % an approximation, correct it
	%m = m / sum(m(:));

