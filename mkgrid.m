%MKGRID Make a planar grid of points
%
%   plane = mkgrid(size, side)
%
%   return a matrix, plane, with one point per column, and each column
%   is the (x, y, z) coordinates of the point.
%
%   the plane is an Nx x Ny grid of points, where sizes is (Nx, Ny) or
%   if scalar Nx = Ny.  The side length of the grid is side
%   and is either (sx, sy) or if scalar sx = sy.
%
%   By default the grid lies in the XY plane, symmetric about the 
%   origin.
%
%   plane = mkgrid(size, side, T)
%
%   applies the homogeneous transform, T, to all points, allowing the plane
%   to be translated or rotated.

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

function p = mkgrid(N, s, varargin)
    
    opt.T = [];


    opt = tb_optparse(opt, varargin);
    if length(s) == 1,
        sx = s; sy = s;
    else
        sx = s(1); sy = s(2);
    end

    if length(N) == 1,
        nx = N; ny = N;
    else
        nx = N(1); ny = N(2);
    end


    if N == 2,
        % special case, we want the points in specific order
        p = [-sx -sy 0
             -sx  sy 0
              sx  sy 0
              sx -sy 0]'/2;
    else
        [X, Y] = meshgrid(1:nx, 1:ny);
        X = ( (X-1) / (nx-1) - 0.5 ) * sx;
        Y = ( (Y-1) / (ny-1) - 0.5 ) * sy;
        Z = zeros(size(X));
        p = [X(:) Y(:) Z(:)]';
    end
    
    % optionally transform the points
    if ~isempty(opt.T)
        p = homtrans(opt.T, p);
    end
