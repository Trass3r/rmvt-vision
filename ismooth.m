%ISMOOTH	Smooth with Gaussian kernel
%
%	ims = ismooth(im, sigma)
%	ims = ismooth(im, sigma, w)
%
%	Smooths all planes of the input image im with a unit volume Gaussian 
%	function of standard deviation sigma.
%
%   The dimension of the Gaussian kernel, w,  can be optionally specified.
%
%	The resulting image is the same size as the input image.
%
% COMMENT ON INT/FLOAT
%
% SEE ALSO:	kgauss

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



function ims = ismooth(im, sigma, varargin)

    if isfloat(im)
        is_int = false;
    else
        is_int = true;
        im = idouble(im);
    end

	m = kgauss(sigma, varargin{:});

	for i=1:size(im,3),
		ims(:,:,i) = conv2(im(:,:,i), m, 'same');
	end

    if is_int
        ims = iint(is_int);
     end
    if ~isfloat(im)
        ims = round(ims);
    end
