%EPILINE Draw epipolar lines
%
%	h = epiline(F, p)
%	h = epiline(F, p, ls)
%
% Draw epipolar lines in current figure based on points specified
% rowwise in p and on the fundamental matrix F.  Optionally specify
% the line style.
%
% The return argument is a vector of graphics handles for the lines.
%
% SEE ALSO:	fmatrix epidist

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

function handles = epiline(F, p, ls)

	% get plot limits from current graph
	xlim = get(gca, 'XLim');
	xmin = xlim(1);
	xmax = xlim(2);

	if nargin < 3,
		ls = 'r';
	end
	h = [];
	% for all input points
	for i=1:numrows(p),
		l = F*[p(i,:) 1]';
		y = (-l(3) - l(1)*xlim) / l(2);
		hold on
		hh = plot(xlim, y, ls);
		h = [h; hh];
		hold off
	end

	if nargout > 0,
		handles = h;
	end
