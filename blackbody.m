%BLACKBODY Compute blackbody emission spectrum
%
% E = BLACKBODY(LAMBDA, T) is the blackbody radiation power density [W/m^3]
% at the wavelength LAMBDA [m] and temperature T [K].
%
% If LAMBDA is a column vector, then E is a column vector whose 
% elements correspond to to those in LAMBDA.  For example:
%
%    l = [380:10:700]'*1e-9; % visible spectrum
%    e = blackbody(l, 6500); % emission of sun
%    plot(l, e)



% Copyright (C) 1993-2011, by Peter I. Corke
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

function e = blackbody(lam, T)
    C1 = 5.9634e-17;
    C2 = 1.4387e-2;
    lam = lam(:);
    e = 2 * C1 ./ (lam.^5 .* (exp(C2/T./lam) - 1));
