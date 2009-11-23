%IFIND	Locate template in image
%
%	S = ifind(T, im)
%
% Return the similarity score for the template T at every location
% in image im.  S is same size as im.
%
% Similarity is not computed where the window crosses the image
% boundary, and is set to NaN.

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

function S = ifind(T, im)

	[nr,nc] = size(im);
    wc = floor( (numcols(T)-1)/2 );
    wr = floor( (numrows(T)-1)/2 );
    wr1 = wr+1;
    wc1 = wc+1;

    S = zeros(size(im)) * NaN;
    
	for c=wc1:nc-wc1,
		for r=wr1:nr-wr1,
			S(r,c) = zncc(T, im(r-wr:r+wr,c-wc:c+wc));
		end
	end
