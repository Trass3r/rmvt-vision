%IM2COL Convert a mono or RGB image to pixel per row format
%
%   col = im2col(im)
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

function c = im2col(im)

    im = shiftdim(im, 2);

    if ndims(im) == 3,
        c = reshape(im, 3, [])';
    else
        c = reshape(im, 1, [])';
    end
