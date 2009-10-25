%SUBPIXEL  Subpixel interpolation of peak
%
%	[dxr, dyr] = subpixel(surf)
%	[dxr, dyr] = subpixel(surf, dx, dy)
%
%  Given a 2-d surface refine the estimate of the peak to subpixel precision/
%  The peak may be given by (dx, dy) or searched for.
%
% SEE ALSO: max2d, imatch, ihough

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

function [ddx,ddy] = subpixel(sim, dx, dy)
	[nr,nc] = size(sim);

	if nargin < 2,
		[dx, dy] = max2d(sim);
	end
	ddx = 0;
	ddy = 0;

	if dx > 1 & dy > 1 & dx < (nc-1) & dy < (nr-1),
		zn = sim(dy-1, dx);
		zs = sim(dy+1, dx);
		ze = sim(dy, dx+1);
		zw = sim(dy, dx-1);
		zc = sim(dy, dx);

		ddx = 0.5*(ze-zw)/(2*zc-zw-ze);
		ddy = 0.5*(zs-zn)/(2*zc-zn-zs);

		if abs(ddx) < 1 & abs(ddy) > 1,
			fprintf('interp too big %f %f\n', ddx, ddy);
			ddx = 0;
			ddy = 0;
		end
	end
