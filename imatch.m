%IMATCH Fast window matching
%
%	[xm,score] = imatch(IM1, IM2, x, y, w2, search)
%
%  Template in IM1 is centered at (x,y), find the best match in IM2 within 
% the region specified by search.  Matching window half-width is w2.
%
% search is the search bounds [xmin xmax ymin ymax] or 
% if a scalar it is [-s s -s s]
%
%  xm is [dx, dy, cc] which are the x- and y-offsets relative to (x, y) 
% and cc is the match (zero-mean normalized cross correlation) score for
% the best match in the search region.
%
% score is a matrix of matching score values of dimensions given by search

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

