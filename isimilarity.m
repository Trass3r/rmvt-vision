%IFIND	Locate template in image
%
%	S = isimilarity(T, im)
%	S = isimilarity(T, im, metric)
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

function S = ifind(T, im, metric)

%TODO add all the other similarity metrics, including rank and census

    if nargin < 3
        metric = @zncc;
    end
	[nr,nc] = size(im);
    hc = floor( (numcols(T)-1)/2 );
    hr = floor( (numrows(T)-1)/2 );
    hr1 = hr+1;
    hc1 = hc+1;

    S = NaN(size(im));
    
	for c=hc1:nc-hc1
		for r=hr1:nr-hr1
			S(r,c) = metric(T, im(r-hr:r+hr,c-hc:c+hc));
		end
	end
