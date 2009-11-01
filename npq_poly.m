%NPQ	Compute central moments of polygon
%
% M = NPQ(iv, p, q)
%	compute the pq'th central moment of the polygon whose vertices are iv.
%
%	Note that the points must be sorted such that they follow the 
%	perimeter in sequence (either clockwise or anti-clockwise).
%
% SEE ALSO: mpq, upq, imoments

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

function m = npq(iv, p, q)

	if (p+q) < 2,
		error('normalized moments: p+q >= 2');
	end
	g = (p+q)/2 + 1;
	m = upq_poly(iv, p, q) / mpq_poly(iv, 0, 0)^g;
