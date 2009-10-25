%NORMHIST	Histogram normalization
%
%	n = inormhist(image)
%
%	Returns a histogram normalized image.  Assumes that pixels lie in the
%	range 0-255.
%
% SEE ALSO:	ihist

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
function [ni,ch] = inormhist(im)
    if size(im,3) > 1
        error('inormhist doesnt support color images');
    end
	[cdf,x] = ihist(im, 'cdf');
	[nr,nc] = size(im);
    
    if isfloat(im)
        ni = interp1(x', cdf', im(:), 'nearest');
    else
        ni = interp1(x', cdf', double(im(:)), 'nearest');
        ni = cast(ni*double(intmax(class(im))), class(im));
    end
    ni = reshape(ni, nr, nc);
