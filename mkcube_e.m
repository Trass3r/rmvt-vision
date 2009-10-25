%MKCUBE2	Create edges of a cube
%
%	xyz = MKCUBE2
%	xyz = MKCUBE2(s)
%	xyz = MKCUBE2(s, c)
%
%	Return a 6-column matrix where each row represents the edge of
%	a cube.  Each row comprises the (x,y,z) coordinates of the start
%	and end of each edge.
%	The side length S defaults to 1.  The centre C = (x,y,z) defaults 
%	to (0,0,0).
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


function xyz = mkcube_e(s, c)
	if nargin < 2
		c = [0 0 0];
    end
	if nargin < 1
		s = 1;
    end
    c = c(:);

    % vertices of a unit cube with one corner at origin
    cube = [
        0     0     1     1     0     0     1     1
        0     1     0     1     0     1     0     1
        0     0     0     0     1     1     1     1 ];



	% cube has 12 edges
	cube = [
		0 0 0 1 0 0
		0 0 0 0 1 0
		0 0 0 0 0 1

		1 1 1 0 1 1
		1 1 1 1 0 1
		1 1 1 1 1 0

		0 0 1 0 1 1
		0 0 1 1 0 1

		1 0 0 1 0 1
		1 0 0 1 1 0

		0 1 0 0 1 1
		0 1 0 1 1 0
	]';

	xyz = s*cube + repmat( c-s/2, 2, 12);
