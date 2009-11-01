%UPQ	Compute normalized central moments of polygon
%
% M = UPQ(iv, p, q)
%	compute the pq'th normalized central moment of the polygon 
%       whose vertices are iv.
%
%	Note that the points must be sorted such that they follow the 
%	perimeter in sequence (either clockwise or anti-clockwise).
%
% SEE ALSO: mpq, npq, imoments

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

function m = upq(iv, p, q)

	m00 = mpq_poly(iv, 0, 0);
	xc =  mpq_poly(iv, 1, 0) / m00;
	yc =  mpq_poly(iv, 0, 1) / m00;

	m = mpq_poly(iv - ones(numrows(iv),1)*[xc yc], p, q);
