%XYHOUGH	XY Hough transform
%
%	H = XYHOUGH(XYZ, drange, Nth)
%
%	Compute the Hough transform of the XY data given as the first two 
%	columns of XYZ.  The last column, if given, is the point strength, 
%	and is used as the increment for the Hough accumulator for that point.
%
% 	The accumulator array has theta across the columns and offset down 
%	the rows.  Theta spans the range -pi/2 to pi/2 in Nth increments.
%	The distance span is given by drange which is either
%		[dmin dmax] in the range dmin to dmax in steps of 1, or
%		[dmin dmax Nd] in the range dmin to dmax with Nd steps.
%
%	Clipping is applied so that only those points lying within the Hough 
%	accumulator bounds are updated.
%
%	The output arguments TH and D give the theta and offset value vectors 
%	for the accumulator columns and rows respectively.  With no output 
%	arguments the Hough accumulator is displayed as a greyscale image.
% 
%	For this version of the Hough transform lines are described by
%
%		d = y cos(theta) + x sin(theta)
%
%	where theta is the angle the line makes to horizontal axis, and d is 
%	the perpendicular distance between (0,0) and the line.  A horizontal 
%	line has theta = 0, a vertical line has theta = pi/2 or -pi/2
%
% SEE ALSO: ihough mkline, mksq, isobel
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

function HH  = xyhough(XYZ, drange, Nth)

	dmin = drange(1);
	dmax = drange(2);
	dinc = 1;
	if length(drange) > 2,
		Nd = drange(3);
	else
		Nd = dmax - dmin + 1;
	end
	dinc = (dmax - dmin) / (Nd - 1);
	
	if numcols(XYZ) == 2,
		XYZ = [XYZ ones(numrows(XYZ),1)];
	end

	% compute the quantized theta values and the sin/cos
	th = [0:(Nth-1)]'/Nth*pi-pi/2;
	st = sin(th);
	ct = cos(th);

	H = zeros(Nd, Nth);		% create the Hough accumulator

	% this is a fast `vectorized' algorithm

	% evaluate the index of the top of each column in the Hough array
	col0 = [0:(Nth-1)]'*Nd;

	for xyz = XYZ',
		x = xyz(1);		% determine (x, y) coordinate
		y = xyz(2);
		inc = xyz(3);
		d = round( ((y * ct - x * st)-dmin)/dinc );	% in the range 0 .. Nd-1

		% which elements are within the column
		inrange = (d>=0) & (d<Nd);

		di = d + col0 + 1;	% convert array of d values to Hough indices
		di = di(inrange);	% ignore those out of column range

		H(di) = H(di) + inc;	% increment the accumulator cells
	end

	dd = [0:(Nd-1)]'*dinc+dmin;

	% if no output arguments display the Hough accumulator
	if nargout == 0,
		image(th,dd,64*H/max(max(H)));
		xlabel('theta (rad)');
		ylabel('intercept');
		colormap(gray(64))
	end
	
	% return output arguments as specified

	if nargout >= 1,
		HH.h = H;
		HH.theta = th;
		HH.d = dd;
	end
