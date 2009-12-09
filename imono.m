%IMONO	Convert color image to monochrome
%
%	im = imono(rgb)
%
% SEE ALSO:	rgb2hsv

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
function im = imono(rgb, opt)

    if size(rgb,3) == 1
        % image is already monochrome
        im = rgb;
        return;
    end

    if nargin < 2
        opt = 'r601';
    end

    switch (lower(opt))
    case 'r601'
        % rec 601 luma
        im = 0.299*rgb(:,:,1) + 0.587*rgb(:,:,2) + 0.114*rgb(:,:,3);

    case 'r709'
        % rec 709 luma
        im = 0.2126*rgb(:,:,1) + 0.7152*rgb(:,:,2) + 0.0722*rgb(:,:,3);
    case 'value'
        % 'value', the V in HSV, not CIE L*
        % the mean of the max and min of RGB values at each pixel
        mx = max(rgb, [], 3);
        mn = min(rgb, [], 3);
        if isfloat(rgb)
            im = 0.5*(mx+mn);
        else
            im = (int32(mx) + int32(mn))/2;
            im = uint8(mx);
        end
    otherwise
        error('unknown option');
    end
