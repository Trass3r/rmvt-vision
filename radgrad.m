%RADGRAD	Compute radially aligned gradient
%
%	[gr,gt] = radgrad(im)
%	[gr,gt] = radgrad(im, center)
%
% At each pixel compute the dot product of image gradient vector with a
% vector radially from the specified center point.  If center point is not
% specified the image is displayed and a point can be selected.
%
% If no output argument is used the result is displayed graphically.
% Return tangential gradient, gt, as well as radial, gr.

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

function [gr,gt] = radgrad(im, center)
	
	if nargin == 1,
		idisp(im);
		[xc,yc] = ginput(1);
	else
		xc = center(1);
		yc = center(2);
	end

	[nr,nc] =size(im);
	[X,Y] = meshgrid(1:nc, 1:nr);
	X = X - xc;
	Y = Y - yc;
	H = sqrt(X.^2 + Y.^2);
	sth = Y ./ H;
	cth = X ./ H;
	[ih,iv] = isobel(im);

	g = sth .* iv + cth .* ih;

	if nargout == 0,
		idisp(g);
	elseif nargout == 1,
		gr = g;
	elseif nargout == 2,
		gr = g;
		gt = cth .* iv + sth .* ih;
	end
