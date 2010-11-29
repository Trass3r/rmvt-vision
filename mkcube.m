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
%	Return a 3-rows matrix where each column contains the (x,y,z) coordinates
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
%  [x,y,z] = mkcube(s, 'edge');
%	Returns three matrices that can be used with mesh(x,y,z) or
%  camera.mesh()
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

function [o1,o2,o3] = mkcube(s, varargin)
    
    opt.centre = [];
    opt.T = [];
    opt.edge = false;
    opt.facepoint = false;

    opt = tb_optparse(opt, varargin);

    % vertices of a unit cube with one corner at origin
    cube = [
       -1    -1     1     1    -1    -1     1     1
       -1     1     1    -1    -1     1     1    -1
       -1    -1    -1    -1     1     1     1     1 ];

    if opt.facepoint
        faces = [
          1    -1     0     0     0     0
          0     0     1    -1     0     0
          0     0     0     0     1    -1 ];
        cube = [cube faces];
    end

    % vertices of cube about the origin
    cube = cube / 2 * s;

    % offset it
    if ~isempty(opt.centre)
        cube = bsxfun(@plus, cube, opt.centre(:));
    end
    % optionally transform the vertices
    if ~isempty(opt.T)
        if isvec(opt.T)
            opt.T = transl(opt.T);
        end
        cube = transformp(opt.T, cube);
    end

    if opt.edge == false
        if nargout <= 1,
            o1 = cube;
        elseif nargout == 3,
            o1 = cube(1,:);
            o2 = cube(2,:);
            o3 = cube(3,:);
        end
    else
        cube = cube(:,[1:4 1 5:8 5]);
        o1 = reshape(cube(1,:), 5, 2)';
        o2 = reshape(cube(2,:), 5, 2)';
        o3 = reshape(cube(3,:), 5, 2)';
    end
