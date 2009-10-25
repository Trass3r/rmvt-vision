%INVHOMOG2	invert (decompose) the image plane homography
%
%	s = invhomog(A)
%
%	where s is an array of structures with elements
%		R 3x3 rotation matrix
%		t 3x1 translation vector
%
%	corresponding to the 8 possible solutions.
%
%	s = invhomog(A, m)
%
%	if a point on the plane is given, m, then infeasible solutions will not
%	be returned.  In the general case this still leaves two solutions.
%
% by method of Kanatani
%
% SEE ALSO: homography


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

function sol = invhomog2(A, m)
	[U,L,V] = svd(A);

	s = det(U)*det(V);

	Lv = diag(L);
	s1 = Lv(1); s2 = Lv(2); s3 = Lv(3);
	u1 = U(:,1);
	u2 = U(:,2);
	u3 = U(:,3);


	% Kanatani p 148
	pp = sqrt((s1-s3)/(s1+s3))/s2*(sqrt(s1^2-s2^2)*u1 + sqrt(s2^2-s3^2)*u3);

	pn = sqrt((s1-s3)/(s1+s3))/s2*(sqrt(s1^2-s2^2)*u1 - sqrt(s2^2-s3^2)*u3);

	hp = (-s3*sqrt(s1^2-s2^2)*u1 + s1*sqrt(s2^2-s3^2)*u3)/(s2*sqrt(s1^2-s3^2));
	hn = (-s3*sqrt(s1^2-s2^2)*u1 - s1*sqrt(s2^2-s3^2)*u3)/(s2*sqrt(s1^2-s3^2));


	% ++
	sol(1).p = pp;
	sol(1).h = hp;

	% +-
	sol(2).p = pp;
	sol(2).h = hn;

	% -+
	sol(3).p = pn;
	sol(3).h = hp;

	% --
	sol(4).p = pn;
	sol(4).h = hn;

	for i=1:4,
		sol(i).R = (eye(3,3) + s2^3*sol(i).p*sol(i).h') * A /s2;
	end
	for i=5:8,
		% duplicate these 4 solutions
		sol(i) = sol(i-4);
		sol(i).R = (-eye(3,3) + s2^3*sol(i).p*sol(i).h') * A /s2;
	end

	if nargin > 1,
		M = [m(:); 1];	% make image point homogeneous
		% we have a point on the plane, cull the solutions
		sol2 = [];
		k = 1;
		for i=1:8,
			AA = (eye(3,3) - sol(i).p*sol(i).h')*sol(i).R;	
			p1 = A*M; p1 = p1./p1(3);
			p2 = AA*M; p2 = p2./p2(3);
			if (norm(cross(p1,p2)) < 1e-6)
				sol2(k).R = sol(i).R;
				sol2(k).h = sol(i).h;
				sol2(k).p = sol(i).p;
				k = k + 1;
			end
		end
		
		sol = sol2;	% return only the feasible solutions
	end
