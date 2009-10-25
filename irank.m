%IRANK	Fast neighbourhood rank filter
%
%	ri = IRANK(image, order, se)
%	ri = IRANK(image, order, se, nbins)
%	ri = IRANK(image, order, se, nbins, edge)
%
%	Performs a rank filter over the neighbourhood specified by SE.  
%	The ORDER'th value in rank becomes the corresponding output pixel value.
%   1 is highest rank, ie. maximum.
%	A histogram method is used with NBINS (default 256).
%
%	Edge handling flags control what happens when the processing window
%	extends beyond the edge of the image. 	EDGE is either
%		'border' the border value is replicated (default)
%		'none'	 pixels beyond the border are not included in the window
%		'trim'	 output is not computed for pixels whose window crosses
%			 the border, hence output image had reduced dimensions.
%		'wrap'	 the image is assumed to wrap around
%
% SEE ALSO:  icircle
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
