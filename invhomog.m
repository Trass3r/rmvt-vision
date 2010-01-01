%INVHOMOG	invert (decompose) the image plane homography
%
%	s = invhomog(H, K)
%
%   H is a planar homography matrix 3x3
%   K is an optional camera intrinsic matrix
%
%	Returns s is an array of structures with elements
%		T 4x4 homogeneous transform matrix
%		n 3x1 normal vector to the plane
%
%	corresponding to the 2 possible solutions that obey the positive
%   depth constraint.
%
%
% REF: An invitation to 3D vision, section 5.3
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

function solutions = invhomog(H, K)

    % normalize H so that the second singular value is one
    [U,S,V] = svd(H);
    H = H/S(2,2);
    
    % compute the SVD of the symmetric matrix H'*H = VSV'
    [U,S,V] = svd(H'*H);
        
    % ensure V is right-handed
    if det(V) < 0,
        fprintf('det(V) was < 0\n');
        V = -V;
    end

    % get the squared singular values
    s1 = S(1,1);
    s3 = S(3,3);

	v1 = V(:,1); v2 = V(:,2); v3 = V(:,3);

    % compute orthogonal unit vectors
    u1 = (sqrt(1-s3)*v1 + sqrt(s1-1)*v3) / sqrt(s1-s3)
    u2 = (sqrt(1-s3)*v1 - sqrt(s1-1)*v3) / sqrt(s1-s3)

	U1 = [v2 u1 cross(v2,u1)]
    W1 = [H*v2 H*u1 skew(H*v2)*H*u1]
    
    U2 = [v2 u2 cross(v2,u2)]
    W2 = [H*v2 H*u2 skew(H*v2)*H*u2]

    % compute the rotation matrices
    R1 = W1*U1';
    R2 = W2*U2';

    % build the solutions, discard those with negative plane normals
    n = cross(v2, u1);
    if n(3) > 0,
        sol(1).n = n;
        t = (H-R1)*n;
    else
        sol(1).n = -n;
        t = -(H-R1)*n;
    end
    sol(1).T = [R1 t; 0 0 0 1];

    n = cross(v2, u2);
    if n(3) > 0,
        sol(2).n = n;
        t = (H-R2)*n;
    else
        sol(2).n = -n;
        t = -(H-R2)*n;
    end
    sol(2).T = [R2 t; 0 0 0 1];
    
    if nargout == 0,
        for i=1:2,
            fprintf('\nsolution %d\n', i);
            show('T =', sol(i).T)
            show('n = ', sol(i).n')
        end
    else
        solutions = sol;
    end

    function show(name, m)
        s = num2str(m, '%12.5f');
        for i=1:numrows(s),
            if i == 1,
                fprintf('%8s%s\n', name, s(i,:));
            else
                fprintf('        %s\n', s(i,:));
            end
        end
