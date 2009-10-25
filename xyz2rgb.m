%XYZ2RGB	Convert XYZ to RGB color space
%
%	rgb = XYZ2RGB(xyz)
%
%	Convert (X,Y,Z) coordinates to (R,G,B) color space.
%	If XYZ (or R, G, B) have more than one row, then computation is
% 	done row wise.
%
% SEE ALSO:	ccxyz cmfxyz
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
function [r,g,b] = xyz2rgb(X,Y,Z)

	a = [
		0.490 0.310 0.200
        0.177 0.813 0.011
        0.000 0.010 0.990];

	if nargin == 3,
		XYZ = [X Y Z];
	elseif nargin == 1,
		XYZ = X;,
	else
		error('wrong number of arguments')
	end

	RGB = [];
	for xyz = XYZ',
		rgb = a*xyz;
		RGB = [RGB rgb];
	end
	RGB = RGB';

	if nargout <= 1
		r = RGB;
	elseif nargout == 3,
		r = RGB(:,1);
		g = RGB(:,2);
		b = RGB(:,3);
	end
