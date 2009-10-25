%IPRINT Print an image to a file
%
%   iprint(filename)
%
% Print the current figure to a file
%
%   iprint(image, filename)
%
% Display the image using idisp2() and then print it to a file


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
function iprint(img, filename)

    path = 'newfigs';

    if nargin == 1,
        % make figure from a plot
        grid on
        filename = img;
        filename = sprintf('%s/%s', path, filename);
        print('-depsc', filename);
        print('-dpng', filename);
    elseif nargin == 2,   
        % make figure from an image
        clf
        idisp2(img);

        filename = sprintf('%s/%s', path, filename);
        if size(img,3) > 1,
            print('-depsc', filename);
            print('-dpng', filename);
        else
            print('-deps', filename);
            print('-dpng', filename);
        end
    end

    clf
