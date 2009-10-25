%IDISP2	Non-interactive image display tool
%
%	IDISP2(image)
%
%	Display the image in current figure and create buttons for:
%		* region zooming
%		* unzooming
%		* drawing a cross-section line.  Intensity along line will be
%		  displayed in a new figure.
%
%	Left clicking on a pixel will display its value in a box at the top.
%
%	The second form will limit the displayed greylevels.  If CLIP is a
%	scalar pixels greater than this value are set to CLIP.  If CLIP is
%	a 2-vector pixels less than CLIP(1) are set to CLIP(1) and those
%	greater than CLIP(2) are set to CLIP(2).  CLIP can be set to [] for
%	no clipping.
%	The N argument sets the length of the greyscale color map (default 64).
%
% SEE ALSO:	iroi, image, colormap, gray
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

function idisp2(z)
	if nargin < 3,
		ncmap = 256;
	end
    ncmap = 256;

	if length(size(z)) == 2,
		% greyscale image
		colormap(gray(ncmap))
		n = ncmap;
        hi = image(z);
    elseif length(size(z)) == 3,
		% color image
		%colormap(gray(ncmap))
		n = ncmap;
        hi = image(z);
    end
    
    figure(gcf);    % bring to top
    
    %xlabel('u (pixels)')
    %ylabel('v (pixels)')
        
	%set(gcf,'ShareColors','off');
	set(hi, 'CDataMapping', 'scaled');
