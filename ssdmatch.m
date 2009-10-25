%SSDMATCH match template to image using SSD matching
%
%compute disparity between two images held in global arrays l and r, about
% the point (x0, y0) in the left image.
%
%  SSD with mean subtraction region matching is used with a window size of 11 x 11
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

function [match,score] = ssdmatch(template, image, start, searchsize, threshold)

	if length(searchsize) == 2,
		rowmax = searchsize(1);
		colmax = searchsize(2);
	else
		rowmax = searchsize;
		colmax = searchsize;
	end

	w = numcols(template);
	h = numrows(template);
	w2 = floor((w-1)/2);
	h2 = floor((h-1)/2);

	lr = template;
	lrm = mean(lr(:));
	lr = lr - lrm;

	s = zeros(2*rowmax+1,2*colmax+1);

	x0 = start(1);
	y0 = start(2);
	for row=-rowmax:rowmax,
		for col=-colmax:colmax,
			rr = image(row+y0-h2:row+y0+h2,col+x0-w2:col+x0+w2);
			rrm = mean(rr(:));
			t = (lr-(rr-rrm)).^2;
			s(row+rowmax+1,col+colmax+1) = sum(t(:));
		end
	end
	%plot(dispar)

	[mn,i] = min(s(:));
	[r,c] = ind2sub(size(s), i);
	best = [c r] - 1 - [colmax rowmax] + start;

	switch nargout
	case 0,
		hold on
		plot(best(1), best(2), 'sy')
		hold off
	case 1,
		match = best;
	case 2,
		score = s;
		match = best;
	end

