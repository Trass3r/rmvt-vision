%ZCROSS		Zero-crossing detector
%
%	IZ = ZCROSS(image)
%
%	Crude zero-crossing detector.  Returns a binary image in which set (1)
%	pixels correspond to negative input pixels adjacent to a transition to
%	transition to a non-negative value.
%
% SEE ALSO:	ilog
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

function iz = zcross(im)

    z = zeros([size(im), 4]);
    K = [1 1 0 ;1 1 0; 0 0 0];
    z(:,:,1) = conv2(im, K, 'same');
    K = [0 1 1 ;0 1 1; 0 0 0];
    z(:,:,2) = conv2(im, K, 'same');
    K = [0 0 0; 1 1 0 ;1 1 0];
    z(:,:,3) = conv2(im, K, 'same');
    K = [0 0 0; 0 1 1 ;0 1 1];
    z(:,:,4) = conv2(im, K, 'same');

    maxval = max(z, [], 3);
    minval = min(z, [], 3);

    iz = (maxval > 0) & (minval < 0);
