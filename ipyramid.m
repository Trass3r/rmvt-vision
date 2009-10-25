%IPYRAMID	Pyramidal image decomposition
%
%	p = ipyramid(im)
%	p = ipyramid(im, sigma)
%	p = ipyramid(im, sigma, N)
%
%	Compute pyramid decomposition of input image, IM, using Gaussian
%	smoothing of sigma (default 1) prior to each decimation.
%
%	If N is specified compute only that number of steps, otherwise the
%	pyramid is computed down to a non-halvable image size.
%
%	Result is a cell array 
%
% SEE ALSO:	kgauss ishrink

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

function p = ipyramid(im, sigma, N)
	if nargin < 2,
		sigma = 1;
		N = floor( log2( min(size(im) ) ) );
	elseif nargin < 3,
		N = floor(log2(min(size(im))));
	end

	[height,width] = size(im);
	K = kgauss(sigma);

	p{1} = im;

	for k = 1:N,
		[nrows,ncols] = size(im);

		% smooth
		im = conv2(im, K, 'same');

		% sub sample
		im = im(1:2:nrows,1:2:ncols);

		% stash it
		p{k+1} = im;
	end
