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
function [T,d,n] = icp3(set1, set2)

	N1 = numrows(set1);	% number of model points
	N2 = numrows(set2);


	p1 = mean(set1);
	p2 = mean(set2);
	t = p2' - p1';
	T = transl(t);
	T = eye(4,4);
	dnorm = 0;
	for count=0:100,
		% transform the observation
		set2t = (T * [set2'; ones(1,numrows(set2))])';
		set2t = set2t(:,1:3);
		%set(h, 'Xdata', set2t(:,1), 'Ydata', set2t(:,2), 'Zdata', set2t(:,3));

		% for each point in set1 find the nearest point in set2
		corresp = [];
		distance = [];
		for i=1:N2,
			d = set1 - ones(N1,1)*set2t(i,:);
			d = d';
			[dmin,k] = min( sum(d.^2) );
			distance(i) = sqrt(dmin);
			corresp(i) = k;
		end

		%disp([distance; corresp])
		% check for big distances, and break the correspondances
		k = find(distance > 2*median(distance));

		% now remove them
		if ~isempty(k),
			fprintf('breaking corespondances '); disp(k);
			distance(k) = [];
			corresp(k) = [];
		end
		set2tmp = set2t;
		set2tmp(k,:) = [];
		fprintf('%d correspondences remaining\n', N2-length(k));

		% display the model points
		usefig('ICP');
		clf
		plot3(set1(:,1),set1(:,2),set1(:,3),'x');
		grid
		hold on
		plot3(set2t(:,1),set2t(:,2),set2t(:,3),'o');

		for i=1:numrows(set2tmp),
			ic = corresp(i);
			plot3( [set1(ic,1) set2tmp(i,1)], [set1(ic,2) set2tmp(i,2)], [set1(ic,3) set2tmp(i,3)], 'r');
		end


		% find the centroids of the two point sets
		% for the observations include only those points which have a
		% correspondance.
		p1 = mean(set1(corresp,:));
		p2 = mean(set2tmp);


		H = zeros(3,3);
		for i=1:numrows(set2tmp),
			H = H + (set1(corresp(i),:) - p1)' * (set2tmp(i,:) - p2);
		end
		%H
		%p1
		%p2

		[u,s,v] = svd(H);
		R = v*u';
		if 0,
			aa = tr2rpy(R);
			a1 = aa(1);
			a2 = aa(2);
			a3 = aa(3);
			if a1 > 0.1,
				a1 = 0.1;
			elseif a1 < -0.1,
				a1 = -0.1;
			end
			if a2 > 0.1,
				a2 = 0.1;
			elseif a2 < -0.1,
				a2 = -0.1;
			end
			if a3 > 0.1,
				a3 = 0.1;
			elseif a3 < -0.1,
				a3 = -0.1;
			end
			R = tr2rot( rpy2tr(a1, a2, a3) );
		end

		if count < 2,
			R = eye(3,3);
		end

			
		%p1-p2
		t = p2' - R*p1';
		
		%disp([t' tr2rpy(R)])

		% update the transform from observation to model, the inverse
		% of our original transformation
		%T = T * inv([R t; 0 0 0 1]);
		T = T * inv([R t; 0 0 0 1]);
		%count = count + 1;
		rpy = tr2rpy(T);
		fprintf('d=%8.3f, t = (%8.3f %8.3f %8.3f), rpy = (%6.1f %6.1f %6.1f)\n', ...
			norm(distance), transl(T), rpy*180/pi);

		disp('----')
		if dnorm > 0,
			if abs(norm(distance) - dnorm)/dnorm < 0.01
				break;
			end
		end
		dnorm = norm(distance);
	end
	fprintf('DONE\n%d iteration\n inv(T) =\n', count); disp(inv(T))
	d = dnorm;
	n = count;
