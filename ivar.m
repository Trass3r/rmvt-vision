%IVAR	Fast neighbourhood variance/kurtosis/skewness 
%
%	V = IVAR(IM, SE, OP)
%	V = IVAR(IM, SE, OP, EDGE)
%
%	Computes the specified statistic over the pixel neighbourhood
%	which becomes the corresponding output pixel value.
%		OP is 'var', 'kurt', 'skew'
%
%	Edge handling flags control what happens when the processing window
%	extends beyond the edge of the image. 	EDGE is either
%		'border' the border value is replicated
%		'none'	 pixels beyond the border are not included in the window
%		'trim'	 output is not computed for pixels whose window crosses
%			 the border, hence output image had reduced dimensions.
%		'wrap'	 the image is assumed to wrap around
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
