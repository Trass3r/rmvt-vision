%SHOWCORNERS	Overlay corner features on image
%
%	[X,Y] = SHOWCORNERS(C, n)
%	F = SHOWCORNERS(C, n)
%	SHOWCORNERS(C, n)
%	SHOWCORNERS(C, n, marker)
%	SHOWCORNERS(C, n, marker, labelsize)
%
%	Returns the coordinates of the N strongest corners in the corner
%	structure C.
%	The second form overlays a blue square at the location of the N 
%	strongest corners.  
%	The third form allows the marker shape/color to be specified using
%	a standard plot() type string, eg. 'sb', or 'xw'
%	Fourth form additionally labels the features in the specified font.
%
% SEE ALSO:	iharris

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

function showcorners(f, n, varargin)
	if nargin == 1,
		n = 10;
    end
    
    if isempty(n) | (n == 0),
        n = length(f.x);
    end

	if n > length(f.x),
		n = length(f.x);
		fprintf('showcorners: only %d features to display\n', n);
	end
	x = [f.x]';
	y = [f.y]';

	markfeatures([x(1:n) y(1:n)], [], varargin{:});
