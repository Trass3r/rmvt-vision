%IHIST	Image histogram (fast)
%
%	ihist(image)
%	h = ihist(image)
%	[h,x] = ihist(image)
%
%	Compute a greylevel histogram of IMAGE.
%
%	The histogram has 256 bins spanning the greylevel range 0-255 or 0-1.
%
%	The first form displays the histogram, the second form returns the
%	histogram.
%
%	[h,x] = ihist(image, N)
%
%   uses N bins, for the case of a double image only.
%
%	[h,x] = ihist(image, 'cdf')
%
%   returns a normalized cumulative histogram.
%
% SEE ALSO:  hist

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

function [h,x] = ihist(im, varargin)

    if size(im, 3) > 1
        % color or multiband image

        np = size(im,3);
        for k=1:np
            [H(:,k),xx] = ihist(im(:,:,k), varargin{:});
        end
        if nargout == 0
            for k=1:np
                subplot(np, 1, k);
                bar(xx, H(:,k));
                xaxis(min(xx), max(xx));
                xlabel(sprintf('Image plane %d', k))
                ylabel('N');
            end
        elseif nargout == 1
            h = H;
        elseif nargout == 2
            h = H;
            x = xx;
        end
        return
    end

    if (nargin > 1) && isinteger(varargin(1))
        N = varargin(1);
    else
        N = 256;
    end

    if isinteger(im)
        [hh,xx] = fhist(im);
    else
        [hh,xx] = hist(im(:), N);
    end

    % computer CDF if requested
    if (nargin > 1) && strcmp(varargin(1), 'cdf')
        hh = cumsum(hh);
        hh = hh ./ hh(end);
    end

    opt = varargin;
	if nargout == 0,
        if (nargin > 1) && strcmp(opt(1), 'cdf')
            opt = opt(2:end);
            plot(xx, hh, opt{:});
            if min(size(im)) > 1
                xlabel('Greylevel')
            end
            ylabel('CDF');
        else
            bar(xx, hh, opt{:});
            xaxis(min(xx), max(xx));
            if min(size(im)) > 1
                xlabel('Greylevel')
            end
            ylabel('Number of pixels');
        end
	elseif nargout == 1,
		h = hh;
	elseif nargout == 2,
		h = hh;
		x = xx;
	end
