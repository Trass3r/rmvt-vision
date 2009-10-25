%BOX	Draw a box on the current plot
%
%	BOX(x1,y1, x2,y2 [,ls]) Draw a box with corners at (x1,y1) and (x2,y2)
%	BOX(x,y, [], w [,ls]) Draw a box with center at (x,y) and side length w

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

function box(x1,y1,x2,y2, varargin)
	if ~isempty(x2)
		p = [	x1 y1
			x2 y1
			x2 y2
			x1 y2
			x1 y1];
	else
		w = y2;
		x = x1; y = y1;
		p = [	x-w y-w
			x+w y-w
			x+w y+w
			x-w y+w
			x-w y-w];
		end
	end

    holdon = ishold
    hold on

    plot(p(:,1), p(:,2), varargin{:})

    if holdon == 0
        hold off
    end
