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

function [h,xbin] = ihist(im, varargin)

% TODO add optparse
%   ihist(im)
%   ihist(im, nbins)
%   ihist(im, options)
%   ihist(im, nbins, options)

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
        nbins = varargin(1);
    else
        nbins = 256;
    end

    if isinteger(im)
        % use quick mex function if data is integer
        [n,x] = fhist(im);
    else
        % remove NaN and Infs from floating point data
        z = im(:);
        k = find(isnan(z));
        z(k) = [];
        if length(k) > 0
            warning('%d NaNs removed', length(k));
        end
        k = find(isinf(z));
        z(k) = [];
        if length(k) > 0
            warning('%d Infs removed', length(k));
        end
        [n,x] = hist(z, nbins);
        n = n'; x = x';
    end

    % handle options
    if nargin > 1
        switch varargin{1}
        case 'cdf'
            % compute CDF if requested
            n = cumsum(n);
        case 'normcdf'
            n = cumsum(n);
            n = n ./ n(end);
        case 'sorted'
            n = sort(n, 'descend');
        end
    end

    opt = varargin;
	if nargout == 0,
        if (nargin > 1) && ~isempty(findstr('cdf', opt{1}))
            opt = opt(2:end);
            plot(x, n, opt{:});
            if min(size(im)) > 1
                xlabel('Greylevel')
            end
            ylabel('CDF');
        else
            bar(x, n, opt{:});
            xaxis(min(x), max(x));
            if min(size(im)) > 1
                xlabel('Greylevel')
            end
            ylabel('Number of pixels');
        end
	elseif nargout == 1,
		h = n;
	elseif nargout == 2,
		h = n;
		xbin = x;
	end
