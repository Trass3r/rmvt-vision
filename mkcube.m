%MKCUBE		Create vertices of a cube
%
%	xyz = MKCUBE
%	xyz = MKCUBE(s)
%	xyz = MKCUBE(s, c)
%
%	[x,y,z] = MKCUBE
%	[x,y,z] = MKCUBE(s)
%	[x,y,z] = MKCUBE(s, c)
%
%	Return a 3-rows matrix where each row contains the (x,y,z) coordinates
%	of a cube's vertices.  The side length S defaults to 1.  The centre
%	C = (x,y,z) defaults to (0,0,0).
%
%	Alternatively the function can be called with 3 output arguments
%	which are vectors of X, Y and Z coordinates.
%
%	xyz = MKCUBE2
%	xyz = MKCUBE2(s)
%	xyz = MKCUBE2(s, c)
%
%	Return a 6-column matrix where each row represents the edge of
%	a cube.  Each row comprises the (x,y,z) coordinates of the start
%	and end of each edge.
%	The side length S defaults to 1.  The centre C = (x,y,z) defaults 
%	to (0,0,0).
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

function [o1,o2,o3] = mkcube(s, T, opt)
	if nargin < 1
		s = 1;
    end

    % vertices of a unit cube with one corner at origin
    cube = [
        0     0     1     1     0     0     1     1
        0     1     0     1     0     1     0     1
        0     0     0     0     1     1     1     1 ];


    if nargin < 3
        % vertices of cube about the origin
        cube = (cube - 0.5) * s;

        if nargin == 2
            % optionally transform the vertices
            if isempty(T)
                T = eye(4,4);
            elseif isvec(T)
                T = transl(T);
            end
            cube = transformp(T, cube);
        end

        if nargout <= 1,
            o1 = cube;
        elseif nargout == 3,
            o1 = cube(1,:);
            o2 = cube(2,:);
            o3 = cube(3,:);
        end
    elseif nargin == 3 && strcmp(opt, 'edges')

        % cube has 12 edges
        cube = [
            0 0 0 1 0 0
            0 0 0 0 1 0
            0 0 0 0 0 1

            1 1 1 0 1 1
            1 1 1 1 0 1
            1 1 1 1 1 0

            0 0 1 0 1 1
            0 0 1 1 0 1

            1 0 0 1 0 1
            1 0 0 1 1 0

            0 1 0 0 1 1
            0 1 0 1 1 0
        ]';

        % vertices of cube about the origin
        cube = (cube - 0.5) * s;

        % optionally transform the vertices
        if isempty(T)
            T = eye(4,4);
        elseif isvec(T)
            T = transl(T);
        end
        o1 = [transformp(T, cube(1:3,:)); transformp(T, cube(4:6,:))];
    end
