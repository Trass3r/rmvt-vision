%KCIRCLE 	Create circular structuring element
%
%	s = kcircle(r)
%	s = kcircle(r, w)
%
%	Return a square matrix of zeros with a central circular region of 
%	radius r of ones.  Matrix size is (2r+1) x (2r+1) or w*w.
%
%	If r is a 2-element vector then it returns an annulus of ones, and
%	the two numbers are interpretted as inner and outer radii.
%
% SEE ALSO: ones imorph

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

function s = kcircle(r, w)

	if ismatrix(r) 
		rmax = max(r(:));
		rmin = min(r(:));
	else
		rmax = r;
	end


	if nargin == 2
        w = w*2 + 1;
    elseif nargin == 1
	    w = 2*rmax+1;
	end
	s = zeros(w,w);

    c = ceil(w/2);

	if ismatrix(r) 
		s = kcircle(rmax,w) - kcircle(rmin, w);
	else
		[x,y] = find(s == 0);
		x = x - c;
		y = y - c;
		l = find(x.^2+y.^2-r^2 <= 0.5);
		s(l) = 1;
	end
