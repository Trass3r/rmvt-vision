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

function lines = invhough(H, n)

	if nargin > 1,
		[z,th,d] = localmax(H.h, n);
	else
		[z,th,d] = localmax(H.h);
	end
	th = H.theta(th);
	d = H.d(d);
	fprintf('  theta        d\n');
	for i=1:length(d),
		fprintf('%10.3f %10.3f\n', th(i), d(i));
	end
	if nargout == 0,
		xlim = get(gca, 'XLim');
		hold on
		for i=1:length(d),
			% y = -tan(theta) x + d/cos(theta)
			y1 = tan(th(i)) * xlim(1) + d(i)/cos(th(i));
			y2 = tan(th(i)) * xlim(2) + d(i)/cos(th(i));
			plot(xlim, [y1 y2], 'r:');
		end
	end
