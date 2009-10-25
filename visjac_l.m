%VISJAC_L	Visual motion Jacobian for line feature
%
%	J = visjac_l(uv, z)
%	J = visjac_l(uv, z, f)
%	J = visjac_l(uv, z, cp)
%
%	Compute the visual Jacobian giving image-plane velocity in terms of
%	camera velocity.  C is a structure of camera intrinsic parameters
%	containing the elements (f, px, py, u0, v0)
%
% REF:	A tutorial on Visual Servo Control, Hutchinson, Hager & Corke,
%	IEEE Trans. R&A, Vol 12(5), Oct, 1996, pp 651-670.
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


function J = visjac_l(uv, z, cp)

	if nargin < 3,
		f = 1;
		ax = 1;
		ay = 1;
		u0 = 0;
		v0 = 0;
	else
		if isstruct(cp),
			f = cp.f;
			ax = cp.px;
			ay = cp.py;
			u0 = cp.u0;
			v0 = cp.v0;
		else
			f = cp;
			ax = 1;
			ay = 1;
			u0 = 0;
			v0 = 0;
		end
	end

	u = uv(1);
	v = uv(2);

	u = uv(1) - u0;
	v = uv(2) - v0;

	J = diag([ax ay]) * [ f/z 0 -u/z -u*v/f (f^2+u^2)/f -v
		0 f/z -v/z -(f^2+v^2)/f u*v/f u];
