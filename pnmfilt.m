%PNMFILT Pipe image through PNM utility
%
% OUT = PNMFILT(IM, PNMCMD) pipes the image IM through a Unix filter program
% and returns its output as an image. The program given by the string PNMCMD
% must accept and return images in PNM format.
%
% Notes::
%  - Provides access to a large number of Unix command line utilities such
%    as ImageMagick.
%
% See also PGMFILT, IREAD.



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

function im2 = pnmfilt(im, cmd)

	% MATLAB doesn't support pipes, so it all has to be done via 
	% temp files :-(

	% make up two file names
	ifile = sprintf('%s.pnm', tempname);
	ofile = sprintf('%s.pnm', tempname);

    imwrite(im, ifile, 'pgm');
	%cmd
	unix([cmd ' < ' ifile ' > ' ofile]);

	im2 = double( imread(ofile) );
	unix(['/bin/rm ' ifile ' ' ofile]);
