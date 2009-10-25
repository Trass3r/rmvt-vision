%ISIMILARITY	Image similarity measure
%
%	m = isimilarity(im1, im2, c1, c2, w)
%
% return similarity of windows in IM1 and IM2.  Window centres are
% C1 and C2 and of side length 2W+1
% Uses the zero-mean normalized cross-correlation between the two
% equally sized image patches w1 and w2.  Result is in the range -1 to 1, with
% 1 indicating identical pixel patterns.
%
%
% SEE ALSO:	zncc

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
function m = isimilarity(im1, im2, c1, c2, w)

	[nr,nc] = size(im1);

	if (c1(1)+w>nc) | (c2(1)+w>nc) | (c1(1)-w<1) | (c2(1)-w<1) ...
		| (c1(2)+w>nr) | (c2(2)+w>nr) | (c1(2)-w<1) | (c2(2)-w<1),
			m = 0;
	else

		m = zncc(im1(c1(2)-w:c1(2)+w,c1(1)-w:c1(1)+w), ...
			im2(c2(2)-w:c2(2)+w,c2(1)-w:c2(1)+w));
	end
