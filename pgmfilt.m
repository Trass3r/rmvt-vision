%PGMFILT Pipe image through PGM utility
%
% OUT = PGMFILT(IM, PGMCMD) pipes the image IM through a Unix filter program
% and returns its output as an image. The program given by the string PGMCMD
% must accept and return images in PGM format.
%
% Notes::
% - Provides access to a large number of Unix command line utilities such
%   as ImageMagick.
%
% See also PNMFILT, IREAD.



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


function im2 = pgmfilt(im, cmd)

    % MATLAB doesn't support pipes, so it all has to be done via temp files...

    % make up two file names
    fname = tempname;
    fname2 = tempname;

    imwrite(im, fname, 'pgm');
    %cmd
    unix([cmd ' < ' fname ' > ' fname2]);
    %fname2
    im2 = imread(fname2, 'pgm');
    unix(['/bin/rm ' fname ' ' fname2]);
