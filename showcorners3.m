%SHOWCORNERS	Overlay corner features on image
%
%	[X,Y] = SHOWCORNERS(C, n, spacing)
%	F = SHOWCORNERS(C, n, spacing)
%	SHOWCORNERS(C, n, spacing)
%	SHOWCORNERS(C, n, spacing, marker)
%	SHOWCORNERS(C, n, spacing, marker, labelsize)
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

function [x,y] = showcorners2(C, n, separation, varargin)
	if nargin == 1,
		n = 10;
		separation = 0;
	elseif nargin == 2,
		separation = 0;
	end

	% get cornerness at each minima location
	cn = C.C(C.l);

	% sort into ascending order, and take the first n
	[cn,i] = sort(cn);	
	i = C.l(i);		% convert to image index

	[nr,nc] =size(C.im);
	[r,c] = ind2sub(size(C.im), i);
	k = (r < separation) | (r > (nr-separation)) | ...
	    (c < separation) | (c > (nc-separation));

	i(k) = [];	% and delete them

	i2 = [];
	for j=1:n,
		% take head of the list to good corner list
		if length(i) == 0,
			fprintf('ran out of features, only got %d\n', j);
			break;
		end
		i2 = [i2; i(1)];
		i = i(2:end);

		% convert raw list to subscripts
		[r,c] = ind2sub(size(C.im), i);
		% convert most recent good feature to subscript
		[r2,c2] = ind2sub(size(C.im), i2(end));
		
		% find all points in raw list close to current good point
		d = sqrt( (r-r2).^2 + (c-c2).^2 );
		k = d < separation;
		i(k) = [];	% and delete them
	end

	i = i2;

	% now take the corresponding indices into the corner array

	% convert to subscripts
	[r,c] = ind2sub(size(C.im), i);

	if nargout == 0,
		if (size(C.im,3) == 1) | (size(C.im,3) == 3),
			idisp(C.im);
		end
		for i=1:length(c),
			if C.plane(r,c) == 1,
				markfeatures([c(i) r(i)], 'ws');
			else
				markfeatures([c(i) r(i)], 'wd');
			end
		end
		%fprintf('C=%f plane=%d  Ix=%f Iy=%f th=%f\n', ...
			%C.C(r,c), C.plane(r,c), C.Ix(r,c), C.Iy(r,c), atan2(C.Iy(r,c), C.Ix(r,c)));
	elseif nargout == 1,
		for i=1:length(r),
			x(i).x = c(i);
			x(i).y = r(i);
		end
	elseif nargout == 2,
		x = c;
		y = r;
	end
