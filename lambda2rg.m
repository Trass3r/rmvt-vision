%CCRGB	RGG chromaticity coordinates
%
%	rgb = CCRGB(lambda)
%		Compute rg chromaticity coordinates for a 
%		specific wavelength.
%
%	rgb = CCRGB(lambda, e)
%		Compute rg chromaticity coordinates for a spectral
%		response e, where elements of e correspond to the wavelength
%		lambda.
%
% SEE ALSO: CMFRGB, CCXYZ
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
function [r,g] = lambda2rg(lambda, e)
	if nargin == 1,
        RGB = cmfrgb(lambda);
	elseif nargin == 2,
        RGB = cmfrgb(lambda, e);
	end
    cc = tristim2cc(RGB);

    if nargout == 1
        r = cc;
    elseif nargout == 2
        r = cc(:,1);
        g = cc(:,2);
    end
