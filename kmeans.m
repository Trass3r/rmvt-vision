%KMEANS	K-means clustering
%
%	[L, C] = kmeans(x, k)
%	[L, C] = kmeans(x, k, x0)
%
%	K-means clustering for data, x.  k is the number of
%	clusters, and x0 if given is the inital centroid for the clusters.
%	x can be 1- or multi-dimensional.
%
%   x0 can be give as a matrix with k rows and size(x,2) columns.
%   Alternatively it can be a string:
%       'random' randomly choose k points from x
%       'spread' randomly choose k values within the hypercube spanned
%           by x.
%
%	On return L is a vector of length equal to size(x,1), whose value 
%  indicates which cluster the corresponding element of x belongs to.
%  C is the cluster centroids, one row per cluster.
%
% REF: Tou and Gonzalez, Pattern Recognition Principles, pp 94

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

% add Kaufman initialization
%
% 1) Initialize c1 with the most centrally located input sample. 
% 2) For i = 2, . . . , K, each ci is initialized in the following 
% way: for each non-selected input sample xj , calculate its 
% summed distance to the other non-selected input samples xl , 
% who are closer to xj than to their respective nearest seed 
% clusters, 
% http://www.comp.nus.edu.sg/~tancl/Papers/IJCNN04/he04ijcnn.pdf
% http://citeseer.ist.psu.edu/398385.html

function [label,centroid] = kmeans(x, K, z0)
	deb = 0;

    n = numrows(x);
    
    if nargin == 2,
        z0 = 'random';
    end
    
    % pick the initial cluster centers if not given
    if isstr(z0),
        if strcmp(z0, 'random'),
            k = randi(n, K, 1);
            z0 = x(k,:);
        elseif strcmp(z0, 'spread'),

            mx = max(x);
            mn = min(x);
            z0 = rand(K,1) * (mx-mn) + ones(K,1)*mn;
            z0
        else
            error('unknown cluster initialization method');
        end
    else
        if numrows(z0) ~= K,
            error('initial cluster length should be k');
        end
        if numcols(z0) ~= numcols(x),
            error('number of dimensions of z0 must match dimensions of x');
        end
    end

    
    % z is the centroid
    % zp is the previous centroid
    % s is the vector of cluster labels corresponding to rows in x
    
    z = z0;
    

	%
	% step 1
	%
	zp = z;             % previous centroids
	s = zeros(n, 1);
    
	iterating = 1;
	k = 1;
	iter = 0;
    
	while iterating,
		iter = iter + 1;

		%
		% step 2
		%
		for l=1:K,
            y(:,l) = colnorm( (x - ones(n,1)*z(l,:))' )';
			[zz,ind] = min(y');
			s = ind';	% assign index of closest set
        end
			
		%
		% step 3
		%
		for j=1:K
			zp(j,:) = mean( x(s==j,:) );
        end

		%
		% step 4
		%
		nm = norm( colnorm( (z - zp)') );
		if deb>0,
			nm
		end
		if nm == 0,
			iterating = 0;
		end
		z = zp;
		if deb>0,
			plot(z);
			pause(.1);
		end
	end
	if deb>0,
		disp('iterations ');
		disp(iter);
    end
    
    if nargout == 0,
        % if no output arguments display results        
        for i=1:K,
            fprintf('cluster %d: %s (%d elements)\n', i, ...
                sprintf('%11.4g ', z(i,:)), length(find(s==i)));
        end
        
        fprintf('\n%d iterations\n', iter);
    end
    if nargout > 0,
        centroid = z;
    end
    if nargout > 1,
        label = s;
    end
