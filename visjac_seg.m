%VISJAC_SEG	visual Jacobian for a line segment

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
function [J,F] = visjac_seg(intrinsics, uv, z)

	f = intrinsics(1);
	ax = intrinsics(2);	% pixels/m
	ay = intrinsics(3);	% pixels/m
	u0 = intrinsics(4);	% principal point in pixels
	v0 = intrinsics(5);	% principal point in pixels

	% convert pixel units to distances at the image plane
	uv = ([1/ax 0 -u0/ax; 0 1/ay -v0/ay] * [uv ones(2,1)]')';

	u = uv(:,1); v = uv(:,2);
	uc = mean(u);
	vc = mean(v);
	d = uv(1,:) - uv(2,:);
	l = norm(d);
	alpha = atan2(d(2), d(1));

	F = diag([ax ay sqrt(ax*ay) 1])*[uc vc l alpha]';


	% now do the Jacobian proper
% derived using Mathematica
Luc = [
	f*(z(1) + z(2))/(2.*z(1)*z(2))
	0
	(l*cos(alpha)*(z(1) - z(2)) - 2*uc*(z(1) + z(2)))/(4.*z(1)*z(2))
	-(8*uc*vc + pow2(l,2)*sin(2*alpha))/(8.*f)
	f + pow2(uc,2)/f + (pow2(l,2)*pow2(cos(alpha),2))/(4.*f)
	-vc
	];

Lvc = [
	0
	(f*(z(1) + z(2)))/(2.*z(1)*z(2))
	(l*sin(alpha)*(z(1) - z(2)) - 2*vc*(z(1) + z(2)))/(4.*z(1)*z(2))
	-(4*(pow2(f,2) + pow2(vc,2)) + pow2(l,2)*pow2(sin(alpha),2))/(4.*f)
	(4*uc*vc + pow2(l,2)*cos(alpha)*sin(alpha))/(4.*f)
	uc
	];

Ll = [
	-((f*l*cos(alpha)*(z(1) - z(2)))/(l*z(1)*z(2)))
	-((f*l*sin(alpha)*(z(1) - z(2)))/(l*z(1)*z(2)))
	-(l*(-2*uc*cos(alpha)*(z(1) - z(2)) - 2*vc*sin(alpha)*(z(1) - z(2)) + l*(z(1) + z(2))))/(2.*l*z(1)*z(2))
	(l*(-3*vc + vc*cos(2*alpha) - uc*sin(2*alpha)))/(2.*f)
	(l*(3*uc + uc*cos(2*alpha) + vc*sin(2*alpha)))/(2.*f)
	0
	];

Lalpha = [
	(f*sin(alpha)*(z(1) - z(2)))/(l*z(1)*z(2))
	(f*cos(alpha)*(-z(1) + z(2)))/(l*z(1)*z(2))
	((vc*cos(alpha) - uc*sin(alpha))*(z(1) - z(2)))/(l*z(1)*z(2))
	(cos(alpha)*sin(alpha)*(-vc + uc*tan(alpha)))/f
	(pow2(cos(alpha),2)*(vc - uc*tan(alpha)))/f
	1
	];

	J = [ Luc'; Lvc'; Ll'; Lalpha'];

	% convert to pixel unit velocities
	%J = diag([ax ay sqrt(ax*ay) 1]) * J;
