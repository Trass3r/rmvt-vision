% $Header: /home/autom/pic/cvsroot/image-toolbox/simplematch.m,v 1.1.1.1 2002/05/26 10:50:25 pic Exp $
% $Log: simplematch.m,v $
% Revision 1.1.1.1  2002/05/26 10:50:25  pic
% initial import
%

% dumb matching of CL and CR corner structures

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

Ncorners = 100;
[xr, yr] = showcorners(CR, Ncorners);
[xl, yl] = showcorners(CL, Ncorners);
sim = [];
for j=1:length(xr),
	% match j'th feature in right image with all features in left
	for i=1:length(xl),
		mm(i) = similarity(left, right, [xl(i) yl(i)], [xr(j) yr(j)], 3);
	end
	[mm,im] = max(mm);
	if mm > 0.8,
		match(j) = im;
	else
		match(j) = 0;
	end
end
usefig('right')
idisp(right)
showcorners(CR, Ncorners)

usefig('left')
idisp(left)
showcorners(CL, Ncorners)
