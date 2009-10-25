%EPIDIST calculate distance of points from epipolar line
%
%	d = epidist(F, pe, p)
%
% F is a fundamental matrix, pe is a Nx2 matrix representing N points for
% which epipolar lines are computed.  p is Mx2 and representes M points
% being tested for distance from each of the N epipolar lines.
%
% d is a NxM matrix, where the element (i,j) is the distance from the j'th
% point in p, to the i'th epipolar line, from pe.
%
% SEE ALSO:	epiline fmatrix
%
% based on fmatrix code by
% Nuno Alexandre Cid Martins
% Coimbra, Oct 27, 1998
% I.S.R.


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


function d = epidist(F, p1, p2)

    l = F*e2h(p1);
	for i=1:numcols(p1),
		for j=1:numcols(p2),
			d(i,j) = abs(l(1,i)*p2(1,j) + l(2,i)*p2(2,j) + l(3,i)) ./ sqrt(l(1,i)^2 + l(2,i)^2);
		end
	end
