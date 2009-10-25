%COL2IM Convert pixel per row format to image
%
%   im = col2im(col, imsize)
%   im = col2im(col, img)
%
% The input, col, is has 1 pixel/row, either 1 (mono) or 3 (RGB) values 
% per row.
%
%  The result is an NxM or NxMx3 images.  imsize is the dimensions [N,M]
% or an image of size NxM or NxMx3, which are used to get the first
% two dimensions.  The number of elements in col must match.

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

function im = col2im(col, img)

    ncols = numcols(col);

    if ~((ncols == 1) | (ncols == 3)),
        error('must be 1 or 3 columns');
    end

    if length(img) == 2,
        sz = img;
    elseif length(img) == 3,
        sz = img(1:2);
    else
        sz = size(img);
        sz = sz(1:2);
    end

    if ncols == 3,
        sz = [sz 3];
    end

    sz
    im = reshape(col, sz);
