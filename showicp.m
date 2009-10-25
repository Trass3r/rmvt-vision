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
function showicp(I)

	rpy = [];
	tr = [];
	for i=1:length(I),
		T = I(i).T;
		if ~isempty(T),
			rpy = [rpy; tr2rpy(T)];
			tr = [tr; transl(T)'];
		end
	end
	usefig('icp tr');
	mplot2([], tr(:,1), tr(:,2), tr(:,3), [[I.n]' [I.n0]']);
	usefig('icp rpy');
	mplot([], rpy);
