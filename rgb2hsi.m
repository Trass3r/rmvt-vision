%RGB2HSI	Transform RGB to HSI color space
%
%	[h s i] = rgb2hsi(r, g, b)
%	[h s i] = rgb2hsi(rgb)
%
%	Convert (r,g,b) color coordinates to HSI coordinates.
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
function [h,s,i] = rgb2hsi(r,g,b)
	
	if ndims(r) == 3,
		g = r(:,:,2);
		b = r(:,:,3);
		r = r(:,:,1);
	end

	i = (r+g+b)/3.0;

% from Alan Roberts' FAQ
	rg = r-g;
	rb = r-b;
	gb = g-b;

	h = acos((0.5*rg + rb) ./ (rg.^2 + sqrt(rb.*gb)))*180/pi;

	a = [r g b];
	s = 1 - 3./i*min(a(:));
