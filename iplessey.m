%IHARRIS		Harris corner detector
%
%	C = IHARRIS(I)
%	C = IHARRIS(I, mask)
%
%	IX and IY are the smoothed squared image gradients.
%
%	Return an image of 'cornerness', C, from the original grey level image
%
% REF:	"A combined corner and edge detector", C.G. Harris and M.J. Stephens
%	Proc. Fourth Alvey Vision Conf., Manchester, pp 147-151, 1988.
%
% SEE ALSO:	showcorners

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
function H = iharris(im, imageMask)

	if ndims(im) == 3,
		% for color image take max of planar cornerness images
		nplanes = size(im,3);
		for i=1:nplanes,
			cc = cornerness(im(:,:,i));
			HH(:,:,i) = cc.C;
		end
		whos
		[rawc,plane] = max(HH, [], 3);
		H.C = rawc;
		H.plane = plane;
		H.im = im;
	else
		% normal grayscale case
		H = cornerness(im);
		rawc = H.C;
	end

	if nargin > 1,
		rawc = rawc .* imageMask;
	end

	% compute minimum value around each pixel
	mask = [1 1 1; 1 0 1; 1 1 1];
	cmin = imorph(rawc, mask, 'min');

	% if pixel less than surrounding minimum, its a local minima, find index
	l = find(rawc < cmin);

	H.l = l;
	H.C = rawc;
	H.nminima = length(l);

	%fprintf('%d minima found\n', length(l));

function H = cornerness(im)
	mask = [-1 0 1; -1 0 1; -1 0 1] / 3;

	% compute horizontal and vertical gradients
	Ix = conv2(im, mask, 'same');
	Iy = conv2(im, mask', 'same');
	
	% compute squares amd product
	Ixy = Ix .* Iy;
	Ix = Ix.^2;
	Iy = Iy.^2;

	% smooth them
	gmask = igauss(1, 1);

	Ix = conv2(Ix, gmask, 'same');
	Iy = conv2(Iy, gmask, 'same');
	Ixy = conv2(Ixy, gmask, 'same');

	% computer cornerness
	H.C = (Ix + Iy) ./ (Ix .* Iy - Ixy.^2);

	H.Ix = Ix;
	H.Iy = Iy;
	H.im = im;
