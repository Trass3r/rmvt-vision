%KDOG	Difference of Gaussian kernel
%
%	k = kdog(sigma1)
%	k = kdog(sigma1, sigma2)
%	k = kdog(sigma1, sigma2, w)
%
%	Returns a difference of Gaussian kernel which can be used for
%	edge detection.
%	The Gaussians have standard deviation of sigma1 and sigma2 
%	respectively, and the convolution kernel has a half size of w, 
%	that is, k is (2W+1) x (2W+1).
%
%	If w is not specified it defaults to 2*sigma.
%
% SEE ALSO:	kgauss conv2

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

function m = kdog(sigma1, sigma2, w)

    % sigma1 > sigma2
    if nargin == 1
        sigma2 = sigma1/1.6;
    elseif nargin < 3
        if sigma2 < sigma1
            t = sigma1;
            sigma1 = sigma2;
            sigma2 = t;
        end
    end
	if nargin < 3
        w = ceil(3*sigma1);
	end

	m1 = kgauss(sigma1, w);
	m2 = kgauss(sigma2, w);

	m = m1 - m2;
