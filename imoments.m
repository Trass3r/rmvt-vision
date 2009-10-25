%IMOMENTS	Compute image moments
%
%	F = imoments(image)
%
%	F = imoments(rows, cols)
%	F = imoments(rows, cols, w)
%
%	The first form computes the grey-scale moments of the image (non-zero 
%	elements) image.  The actual pixel values are used as pixel weights.
%	The return vector is a structs
%		F.area     is the number of pixels (for a binary image)
%		F.x        (x, y) is the centroid with respect 
%		F.y           to top-left point which is (1,1)
%		F.a        (a, b) are axis lengths of the "equivalent 
%		F.b           ellipse"
%		F.theta    the angle of the major ellipse axis to the 
%		                horizontal axis.
%
%	The raw moments are also returned:
%		F.m00
%		F.m10
%		F.m01
%		F.m20
%		F.m02
%		F.m11
%
%	The second form is used when the coordinates of the non-zero elements 
%	are known and V is a vector of the same length containing the weights
%	for pixel values.
%
% NOTE:	this function does not perform connectivity, if connected blobs
%	are required then the ILABEL function must be used first.
%
% SEE ALSO: ilabel

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


function F = imoments(a1, a2, a3)
	if nargin == 1,
		[i,j] = find(a1);
		w = a1(find(a1 > 0));
	else
		i = a1;
		j = a2;
		if nargin == 3,
			w = a3;
		else
			w = ones(size(i));
		end
	end

	% compute basic moments
	m00 = sum(w);
	m10 = sum(j.*w);
	m01 = sum(i.*w);
	m20 = sum((j.^2).*w);
	m02 = sum((i.^2).*w);
	m11 = sum((i.*j).*w);

	if m00 > 0,
		% figure some central moments
		u20 = m20 - m10^2/m00;
		u02 = m02 - m01^2/m00;
		u11 = m11 - m10*m01/m00;

		% figure the equivalent axis lengths, function of the principal axis lengths
		e = eig([u20 u11; u11 u02]);
		a = 2*sqrt(max(e)/m00);
		b = 2*sqrt(min(e)/m00);
		th = 0.5*atan2(2*u11, u20-u02);
	else
		u20 = NaN;
		u02 = NaN;
		u11 = NaN;

		a = NaN;
		b = NaN;
		th = NaN;
	end

	%F = [m00 m10/m00 m01/m00 a b th];
    F = Blob;
	F.area = m00;
	if m00 > 0,
		F.x = m10/m00;
		F.y = m01/m00;
	else
		F.x = NaN;
		F.y = NaN;
	end
	F.a = a;
	F.b = b;
    F.shape = b/a;
	F.theta = th;
	F.m.m00 = m00;
	F.m.m01 = m01;
	F.m.m10 = m10;
	F.m.m02 = m02;
	F.m.m20 = m20;
	F.m.m11 = m11;
    F.m.u20 = u20;
    F.m.u02 = u02;
    F.m.u11 = u11;
