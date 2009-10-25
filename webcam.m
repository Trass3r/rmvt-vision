%WEBCAM  Load frame from an Axis webcam.
%
%  im = webcam(url);
%
%  Load image from the Axis webcam at the specified URL.
%
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

function imout = webcam(url)

	%im = imread( sprintf('%s/axis-cgi/mjpg/video.cgi?resolution=640x480', url) );
	im = imread( sprintf('%s/jpg/image.jpg', url) );
	%[nr,nc] = size(im);
	%im = im(nr:-1:1,:,:);


	if nargout == 0,
		image(im);
	else
		imout = im;
	end
