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
function [T,d] = icp3(set1, set2, varargin)

    % T is the transform from set1 to set2
    opt.maxtheta = 0.05;
    opt.maxiter = 100;
    opt.mindelta = 0.001;
    opt.plot = false;
    opt.distthresh = [];
    opt = tb_optparse(opt, varargin);
    
	N1 = numcols(set1);	% number of model points
	N2 = numcols(set2);

	p1 = mean(set1');
	p2 = mean(set2');
	t = p2 - p1;
	T = transl(t);
    
	dnorm = 0;
    dnorm_p = NaN;
    
	for count=1:opt.maxiter
        
		% transform the model
        set1t = transformp(T, set1);

		% for each point in set 2 find the nearest point in set 1       
        [corresp,distance] = closest(set2, set1t);
        
        if isempty(opt.distthresh)
            set2t = set2;
        else
            k = find(distance > 2*median(distance));

            % now remove them
            if ~isempty(k),
                fprintf('breaking %d corespondances ', length(k));
                distance(k) = [];
                corresp(k) = [];
            end
            set2t = set2;
            set2t(:,k) = [];
        end
        
		% display the model points
		if opt.plot
            usefig('ICP');
            clf
            plot3(set1t(1,:),set1t(2,:),set1t(3,:),'bx');
            grid
            hold on
            plot3(set2t(1,:),set2t(2,:),set2t(3,:),'ro');

            for i=1:numcols(set2t),
                ic = corresp(i);
                plot3( [set1t(1,ic) set2t(1,i)], [set1t(2,ic) set2t(2,i)], [set1t(3,ic) set2t(3,i)], 'g');
            end
            pause(0.25)
        end

		% find the centroids of the two point sets
		% for the observations include only those points which have a
		% correspondance.
		p1 = mean(set1t(:,corresp)');
        %[length(corresp)         length(unique(corresp))]
        p1 = mean(set1t');
		p2 = mean(set2t');

        % compute the moments
		M = zeros(3,3);
		for i=1:numcols(set2t)
            ic = corresp(i);
			M = M + (set1t(:,ic) - p1') * (set2t(:,i) - p2')';
        end
        
		[U,S,V] = svd(M);
        
        % compute the rotation of p1 to p2
        % p2 = R p1 + t
		R = V*U';

        if det(R) < 0
            warning('rotation is not in SO(3)');
            R = -R;
        end
        
        if opt.debug
            p1
            p2
            M
            R
        end
        
        % optionally clip the rotation, helps converence
		if ~isempty(opt.maxtheta)
			[theta,v] = tr2angvec(R);
            if theta > opt.maxtheta;
                theta = opt.maxtheta;
            elseif theta < -opt.maxtheta
                theta = -opt.maxtheta;
            end
            R = angvec2r(theta, v);
        end
        if opt.debug
            theta
            v
            R
        end

			
		% determine the incremental translation
        t = p2' - p1';
		
		%disp([t' tr2rpy(R)])

		% update the transform from observation to model, the inverse
		% of our original transformation
		T = trnorm( T * [R t; 0 0 0 1] );
		%count = count + 1;
		rpy = tr2rpy(T);
		
        dnorm = norm(distance);
        
        if opt.verbose
            fprintf('d=%8.3f, t = (%8.3f %8.3f %8.3f), rpy = (%6.1f %6.1f %6.1f) deg\n', ...
			dnorm, transl(T), rpy*180/pi);
        end

        % check termination condition
        if abs(dnorm - dnorm_p)/dnorm_p < opt.mindelta
            count = NaN;    % flag that we exited on mindelta
            break
        end
		dnorm_p = dnorm;
    end
    
    if opt.verbose
        if isnan(count)
                fprintf('terminate on minimal change of error norm');
        else
            fprintf('terminate on iteration limit (%d iterations)\n', opt.maxiter);
        end
    end
    
    if nargout > 1
        d = dnorm;
    end
