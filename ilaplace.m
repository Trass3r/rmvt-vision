%ILAPLACE	Convolve with Laplacian kernel
%
%	im2 = ilaplace(image)
%
%	Return the image after convolution with the Laplacian kernel
%		0 -1  0
%		-1 4 -1
%		0 -1  0
%
%  The returned image is the same size as the original image and pixels that
% result from the convolution mask exceeding the image bounds are set to zero.
%
% SEE ALSO:	ilog conv2

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

function il = ilaplace(im, sigma, varargin);

    % perform the convolution, same size output image
    if nargin == 1 || isempty(sigma)
        il = conv2(im, klaplace(), varargin{:});
    else
        il = conv2(im, klog(sigma), varargin{:});
    end

%    % set edge pixels to zero
%    il(1,:) = 0;
%    il(end,:) = 0;
%    il(:,1) = 0;
%    il(:,end) = 0;
	
