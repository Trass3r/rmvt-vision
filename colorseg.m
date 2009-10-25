%COLORSEG  Color image segmentation using k-means
%
%   [L,c] = colorseg(im, k)
%
% Segment the color image into k classes.
%
%   [L,c] = colorseg(im, k, options)
%
% Options include:
%   'spread' use k-means 'spread' initializer instead of random point
%   'pick' interactively pick cluster centres

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
function [labels,C] = colorseg(im, k, varargin)

    % convert RGB to xy space
    rgbcol = im2col(im);
    XYZcol = rgb2xyz(rgbcol);
    sXYZ = sum(XYZcol')';
    x = XYZcol(:,1) ./ sXYZ;
    y = XYZcol(:,2) ./ sXYZ;
    
    % do the k-means clustering
    
    if nargin < 2,
        k = 4;
    end
    
    if length(varargin) > 0,
        if varargin{1} == 'pick',
            z0 = pickpoints(k, im, x, y);
            [L,C] = kmeans([x y], k, z0);
        end
    else
        [L,C] = kmeans([x y], k);
    end
    
    
    % convert labels back to an image
    L = col2im(L, im);
    
    idisp(L);
    
    for k=1:numrows(C),
        fprintf('%2d: ', k);
        fprintf('%11.4g ', C(k,:));
        fprintf('\n');
        %fprintf('%s\n', colorname(C(k,:)));
    end
    
    if nargout > 0,
        labels = L;
    end
end
    
function z0 = pickpoints(k, im, x, y)

    fprintf('Select %d points to serve as cluster centres\n', k);
    clf
    image(im)
    uv = round( ginput(k) );
    sz = size(im);
    i = sub2ind( sz(1:2), uv(:,2), uv(:,1) )
    
    z0 =[x(i) y(i)];
end
