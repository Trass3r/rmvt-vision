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

function showepi(F, im1, im2, p1, p2)

	if nargin >=3 3,
		usefig('one')
		idisp(im1);
		usefig('two')
		idisp(im2);
	end

	if nargin == 5,
		usefig('one')
		markfeatures(p1, 'sb', 8);
		usefig('two')
		markfeatures(p2, 'sb', 8);
	end

	usefig('one')
	if nargin == 3,
		point = ginput(1);
		usefig('two')
		uvec = get(gca, 'XLim');
		l = F*[point 1]';
		vvec = (-l(1)*uvec - l(3)) / l(2);
		hold on
		plot(uvec, vvec, 'w')
		plot(point(:,1), point(:,2), 'ow');
		hold off
	elseif nargin == 5,
		usefig('two')
		uvec = get(gca, 'XLim');
		hold on
		for i=1:length(p1),
			point = p1(i,:);
			l = F*[point 1]';
			vvec = (-l(1)*uvec - l(3)) / l(2);
			plot(uvec, vvec, 'w')
			plot(point(:,1), point(:,2), 'ow');
		end
		hold off
	end
