%ISOBEL	Sobel edge detector
%
%	is = isobel(image)
%	is = isobel(image, Dx)
%	[ih,iv] = isobel(image)
%	[ih,iv] = isobel(image, Dx)
%
%	Applies the Sobel edge detector, which is the norm of the vertical
%	and horizontal gradients.  Tends to produce rather thick edges.
%	Returns either the magnitude image or horizontal and vertical 
%	components.
%
%	If Dx is specified this x-derivative kernel is used instead
%	of the default:
%			-1  0  1
%			-2  0  2
%			-1  0  1
%
%	The resulting image is the same size as the input image.

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

function [o1,o2] = isobel(i, Dx)

	if nargin < 2,
		sv = -[	-1 -2 -1
			0 0 0
			1 2 1];
		sh = sv';
	else
		% use a smoothing kernel if sigma specified
		sh = Dx;
		sv = Dx';
	end

	ih = conv2(i, sh, 'same');
	iv = conv2(i, sv, 'same');

	% return grandient components or magnitude
	if nargout == 1,
		o1 = sqrt(ih.^2 + iv.^2);
	else
		o1 = ih;
		o2 = iv;
	end
