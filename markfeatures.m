%MARKFEATURES	Overlay corner features on image
%
%	markfeatures(xy)
%	markfeatures(xy, N)
%	markfeatures(xy, N, marker)
%	markfeatures(xy, N, marker, label)
%
%	Mark specified points in current image with a blue square 
%	xy can be an n x 2 matrix or a feature structure vector with 
%	elements x and y.
%
%	If N is specified it limits the number of points plotted.  If N = 0
%	then all points are plotted.
%
%	The third form allows the marker shape/color to be specified using
%	a standard plot() type string, eg. 'sb', or 'xw'.
%
%	Fourth form uses cell array label to control labelling of each
%	mark, label at font size label{1} and color label{2}.

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

function markfeatures(p, N, marker, label)

	if isstruct(p),
		r = [p.y]';
		c = [p.x]';
	else
		r = p(:,2);
		c = p(:,1);
    end

	if nargin > 1,

		if isempty(N) || (N == 0),
			N = length(r);
        end
		r = r(1:N);
		c = c(1:N);
	end
	if nargin < 3,
		marker = 'sb';
    end
	hold on
	for i=1:length(r),
		plot(c(i), r(i), marker);
		if nargin == 4,
			text(c(i), r(i), sprintf('  %d', i), ...
                'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'middle', ...
				'FontUnits', 'pixels', ...
				'FontSize', label{1}, ...
				'Color', label{2});

		end
	end
	hold off
    figure(gcf)
