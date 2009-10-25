%SCALESPACE  Return scale-space image sequence
%
%   [L,G,scale] = scalespace(im, n);
%   [L,G,scale] = scalespace(im, n, sigma);
%
% where im is the input image, n the length of the scale space sequence, and sigma
% is the width of the Gaussian.  At each scale step the variance of the Gaussian
% increases by sigma^2.  The first step in the sequence is the original image.
%
% L is the absolute value of the Laplacian of the scale sequence, G is the scale sequence,
% and scale is the vector of scales used at each step of the sequence.
%
% SEE ALSO: ismooth, ilaplace


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

function [L, G, S] = scalespace(im, n, sigma)

    if nargin < 3,
        sigma = 1;
    end

    g(:,:,1) = im;
    lap(:,:,1) = abs( ilaplace(im) );
    scale = 1;
    scales = scale;
    for i=1:n-1,
        im = ismooth(im, sigma^2);
        scale = scale * sigma^2;
        scales = [scales; scale];
        g(:,:,i+1) = im;
        lap(:,:,i+1) = scale * abs( ilaplace(im) );
    end

    % return results as requested
    if nargout > 2,
        S = scales;
    end
    if nargout > 1,
        G = g;
    end
    if nargout > 0,
        L = lap;
    end
