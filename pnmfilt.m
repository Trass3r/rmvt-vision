%PNMFILT	Pipe image through PNM utility
%
%	f = pnmfilt(im, cmd)
%
%	Pipe image through a Unix filter program.  Input and output image 
%	formats	are PNM.
%
% SEE ALSO: xv savepnm

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

function im2 = pnmfilt(im, cmd)

	% MATLAB doesn't support pipes, so it all has to be done via 
	% temp files :-(

	% make up two file names
	ifile = sprintf('%s.pnm', tempname);
	ofile = sprintf('%s.pnm', tempname);

	savepnm(ifile, im);
	%cmd
	unix([cmd ' < ' ifile ' > ' ofile]);

	im2 = double( imread(ofile) );
	unix(['/bin/rm ' ifile ' ' ofile]);
