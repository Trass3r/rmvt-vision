%COLORIZE Colorize a greyscale image according to binary mask
%
%   c = colorize(grey, mask, color)
%
%  The result is a color image where each pixel is greyscale where
%  the mask image is false, and the specified color where it is true.
%  The color is specified as a 3-vector (R,G,B)
%
%   c = colorize(grey, func, color)
%
%  Instead of a mask we pass in a handle to a function that returns
% a logical result, eg. @isnan
%
%  If no output argument the resulting image is displayed using image()

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

function co = colorize(img, mask, color)

    if isa(img, 'uint8') || isa(img, 'logical') 
        grey = double(img) / 255;
    else
        grey = img / max(img(:));
    end

    g = grey(:);
    z = [g g g];
    if isa(mask, 'function_handle')
        mask = mask(img);
    end

    k = find(mask(:));
    z(k,:) = ones(numrows(k),1)*color(:)';
    z = reshape(z, [size(grey) 3]);

    if nargout > 0
        co = z;
    else
        image(z);
        shg
    end
