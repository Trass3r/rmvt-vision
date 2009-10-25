%ICLOSE	Morphological closing
%
%	b = iclose(im)
%	b = iclose(im, se)
%	b = iclose(im, se, n)
%
%	Return the image im after morphological closing with the structuring
%	element se (default to ones(3,3).   n (default to 1) dilations then 
%	N erosions are performed.
%
% SEE ALSO:	iopen imorph

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


function b = iclose(a, se, n)

	if nargin < 3,
		n = 1;
	end
	if nargin < 2,
		se = ones(3,3);
	end

	b = a;
	for i=1:n,
		b = imorph(b, se, 'max');
	end
	for i=1:n,
		b = imorph(b, se, 'min');
	end
