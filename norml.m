%NORML	Normalize homogenous vectors
%
%	N = norml(V)
%	N = norml(M)
%
%  Normalize V such that last element is 1, and discard that element.
%  If M is a matrix peform the norml function on each row.

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

function N = norml(v)

    if isvector(v),
        N = v ./ v(end);
        N = N(1:end-1);
    else
        N = v(:,1:end-1);
        N = N ./ (ones(numcols(N), 1) * v(:,end)')'
    end
