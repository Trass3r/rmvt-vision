%SIMAREA	image similarity measure
%
%	simarea(im1, im2, c1, r2, w)
%
%	r2 = [x1 x2 y1 y2]
% return similarity of windows in IM1 and IM2.  Window centres are
% C1 and C2 and of side length 2W+1
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

function [mmax,where] = simarea(im1, im2, c1, r2, w)

	[nr,nc] = size(im1);

	template = im1(c1(2)-w:c1(2)+w,c1(1)-w:c1(1)+w);

	x1 = r2(1); x2 = r2(2);
	y1 = r2(3); y2 = r2(4);

	mmax = -1;
	for y=y1+w:y2-w,
		for x=x1+w:x2-w,
			m = zncc(template, ...
				im2(y-w:y+w,x-w:x+w));
			if m > mmax,
				mmax = m;
				where = [x y];
			end
		end
	end
