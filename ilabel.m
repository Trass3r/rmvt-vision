%ILABEL	Label an image
%
%		li = ilabel(image [, connect])
%		[li,maxlabel] = ilabel(image [, connect])
%		[li,maxlabel,parents] = ilabel(image [, connect])
%
%	Perform connectivity analysis and return a label image LI, same size as 
%	IMAGE where each pixel value represents the label of the region of its
%	corresponding pixel in IMAGE.
%
%	Connectivity is performed using 4 or 8 nearest neighbour as controlled
%	by the optional connect argument.  Default is 4 way but can be changed
%	to 8.  The function compares the pixel values so the image can be 
%	greyscale or binary.
%
%	Also returns the maximum label assigned to the image.  Labels lie in
%	the range 1 to MAXLABEL.
%
%	The third form also returns region hierarchy information.  The
%	value of parents[i] is the label of the 'parent' or enclosing
%	region of region i.  A value of 0 indicates that the region has
%	no enclosing region.
%
% SEE ALSO:	imoments iblobs
%
% LIMITATIONS:	should allow for different connectivity modes

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

