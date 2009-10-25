%ISTRETCH	Image linear normalization
%
%	g = istretch(image)
%	g = istretch(image, newmax)
%
%	Return a normalized image in which all pixels lie in the range
%	0 to 1, or 0 to newmax.
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


function zs = istretch(z, newmax)

	if nargin == 1,
		newmax = 1;
	end

	mn = min(z(:));
	mx = max(z(:));

	zs = (z-mn)/(mx-mn)*newmax;
