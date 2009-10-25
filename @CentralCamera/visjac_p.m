%VISJAC_P	Visual motion Jacobian for point feature
%
%	Compute the 2x6 visual Jacobian giving image-plane velocity in terms of
%	camera velocity. 
%
%	vj = visjac_p(ci, uv, z)
%
%   ci is a structure of camera intrinsic parameters with
%   elements (f, sx, sy, u0, v0), uv is the image plane coordinate (u,v)
%   and z is the point depth.
%
%   If uv and z each have N rows, then the result is a 2Nx6 stack of
%   Jacobians for each image plane point, a row of uv.
%
% REF:	A tutorial on Visual Servo Control, Hutchinson, Hager & Corke,
%	IEEE Trans. R&A, Vol 12(5), Oct, 1996, pp 651-670.
%

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modifv
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

function vj = visjac_p(cam, uv, z)

    if numrows(uv) > 1,
        vj = [];
        % recurse for each point
        for i=1:numrows(uv),
            vj = [vj; visjac_p(cam, uv(i,:), z(i))];
        end
        return;
    end
    
    % some shorthand
    fu = cam.f / cam.sx;
    fv = cam.f / cam.sy;
	u = uv(1,1) - cam.u0;
	v = uv(1,2) - cam.v0;

    % first row
	vjx = [
		-fu/z
		0
		u/z
		u*v/fu
		-(fu^2+u^2)/fu
        v
	];

    % second row
	vjy = [
		0
		-fv/z
		v/z
		(fv^2+v^2)/fv
		-u*v/fv
		-u
	];
	vj = [vjx'; vjy'];
