%LOADSPECTRUM	Load spectrum data
%
%	s = loadspectrum(lambda, filename)
%	[s,lambda] = loadspectrum(lambda, filename)
%
%   Return spectral data interpolated to wavelengths specified in lambda.
%
%   File is assumed to have its first column as wavelength in metres, the remainding
%   columns are interpolated and returned.
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

function [s,lam] = loadspectrum(lambda, filename)

    lambda = lambda(:);
	tab = load(filename);

    s = interp1(tab(:,1), tab(:,2:end), lambda);

    if nargout == 2
        lam = lambda;
    end
