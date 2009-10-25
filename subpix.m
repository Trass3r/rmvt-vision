%SUBPIX subpixel interpolation
%
%	XM = SUBPIX(XM, SCORE)
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

function xms = subpix(xm, score, search)

	if length(search) == 1,
		xmin = -search;
		ymin = -search;
	else
		xmin = search(1);
		ymin = search(3);
	end

	cx = xm(1) - xmin + 1;
	cy = xm(2) - ymin + 1;

	zN = score(cy-1,cx);
	zS = score(cy+1,cx);
	zE = score(cy,cx+1);
	zW = score(cy,cx-1);
	zC = score(cy,cx);

	dx = -(zW-zE)/(-zW-zE+2.0*zC)/2.0;
	dy = -(zN-zS)/(-zN-zS+2.0*zC)/2.0;

	xms = xm;
	if (abs(dx) < 1) & (abs(dy) < 1),
		xms(1) = xms(1) + dx;
		xms(2) = xms(2) + dy;
	end

