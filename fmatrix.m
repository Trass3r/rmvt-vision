%FMATRIX	estimate the fundamental matrix
%
%	F = FMATRIX(Pa, Pb [, how])
%
%	Given two sets of corresponding points Pa and Pb (each an nx2 matrix)
%	return the fundamental matrix relating the two sets of observations.
%
%	The epipolar line is F*[pa 1] and corresponding points pb will lie
%	on this line.
%
% SEE ALSO: homography frefine epiline epidist

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



function [F, resid] = fmatrix(p1, p2)

    % RANSAC integration
    if isstruct(p1)
        F = ransac_driver(p1);
        return;
    end

    if numcols(p1) < 7
        error('must be at least 7 corresponding points');
    end

    % get data from passed arrays into homogeneous p1 and p2
    %
    %  if 6xN assume that data is conditioned
    X = p1;


    if numrows(X) == 6
        p1 = X(1:3,:);
        p2 = X(4:6,:);
        C1 = eye(3,3);
        C2 = eye(3,3);
    else
        % data is not conditioned
        if numrows(X) == 4
            p1 = X(1:2,:);
            p2 = X(3:4,:);
        elseif numrows(p1) == 2,
            if nargin < 2,
                error('must pass uv1 and uv2');
            end
            p1 = X;
            if numcols(p1) ~= numcols(p2),
                error('must have same number of points in each set');
            end
            if numrows(p1) ~= numrows(p2),
                error('p1 and p2 must have same number of rows')
            end
        end
        
        % make data homogeneous
        p1 = e2h(p1);
        p2 = e2h(p2);
        
        % and condition it
        C1 = vgg_conditioner_from_pts(p1);
        C2 = vgg_conditioner_from_pts(p2);
        p1 = vgg_condition_2d(p1, C1);
        p2 = vgg_condition_2d(p2, C2);
    end


    if numcols(p1) == 7,
        % special case of 7 points

        Fvgg = vgg_F_from_7pts_2img(p1, p2);

        if isempty(Fvgg)
            F = [];
        else
        
            % Store the (potentially) 3 solutions in a cell array
            Nsolutions = size(Fvgg, 3);
            for n = 1:Nsolutions
                F{n} = Fvgg(:,:,n);
            end
        end
        resid = 0;
        return;
    else
        % normal case

        x1 = p1(1,:)';
        y1 = p1(2,:)';
        x2 = p2(1,:)';
        y2 = p2(2,:)';

        % linear estimate
        A = [x1.*x2 y1.*x2 x2 x1.*y2 y1.*y2 y2 x1 y1 ones(size(x1))];
        [U,S,V] = svd(A);

        f = V(:,end);
        F = reshape(f, 3, 3)';

        % enforce the rank 2 constraint
        [U,S,V] = svd(F);
        S(3,3) = 0;
        F = U * S * V';

        % check the residuals
        d = fdist(F, p1, p2);
        resid = max(d);
        if nargout < 2,
            fprintf('maximum residual %.4g\n', resid);
        end

        % decondition the result
        F = C2' * F * C1;
    end
end

%----------------------------------------------------------------------------------
%   out = fmatrix(ransac)
%
%   ransac.cmd      string      what operation to perform
%       'size'
%       'condition'
%       'decondition'
%       'valid'
%       'estimate'
%       'error'
%   ransac.debug    logical     display what's going on
%   ransac.X        6xN         data to work on
%   ransac.t        1x1         threshold
%   ransac.theta    3x3         estimated quantity to test
%   ransac.misc     cell        private data for deconditioning
%
%   out.s           1x1         sample size
%   out.X           6xN         conditioned data
%   out.misc        cell        private data for conditioning
%   out.inlier      1xM         list of inliers
%   out.valid       logical     if data is valid for estimation
%   out.theta       3x3         estimated quantity
%----------------------------------------------------------------------------------

function out = ransac_driver(ransac)
    cmd = ransac.cmd;
    if ransac.debug
        fprintf('RANSAC command <%s>\n', cmd);
    end
    switch cmd
    case 'size'
        % return sample size
        out.s = 8;
    case 'condition'
        if numrows(ransac.X) == 4
            p1 = ransac.X(1:2,:);
            p2 = ransac.X(3:4,:);
            p1 = e2h(p1);
            p2 = e2h(p2);
        elseif numrows(ransac.X) == 6
            p1 = ransac.X(1:3,:);
            p2 = ransac.X(3:6,:);
        end

        % condition the point data
        C1 = vgg_conditioner_from_pts(p1);
        C2 = vgg_conditioner_from_pts(p2);
        p1 = vgg_condition_2d(p1, C1);
        p2 = vgg_condition_2d(p2, C2);
        out.X = [p1; p2];
        out.misc = {C1, C2};
    case 'decondition'
        F = ransac.theta;
        misc = ransac.misc;
        C1 = misc{1}; C2 = misc{2};
        out.theta = C2' * F * C1;
    case 'valid'
        out.valid = true;
    case 'error'
            % [bestInliers, bestF] = funddist(F, x, t);
        [out.inliers, out.theta] = funddist(ransac.theta, ransac.X, ransac.t);
    case 'estimate'
        [out.theta, out.resid] = fmatrix(ransac.X);
    otherwise
        error('bad RANSAC command')
    end
end

%--------------------------------------------------------------------------
% Function to evaluate the first order approximation of the geometric error
% (Sampson distance) of the fit of a fundamental matrix with respect to a
% set of matched points as needed by RANSAC.  See: Hartley and Zisserman,
% 'Multiple View Geometry in Computer Vision', page 270.
%
% Note that this code allows for F being a cell array of fundamental matrices of
% which we have to pick the best one. (A 7 point solution can return up to 3
% solutions)
	
% Copyright (c) 2004-2005 Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% http://www.csse.uwa.edu.au/
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
%
% The Software is provided "as is", without warranty of any kind.

% February 2004  Original version
% August   2005  Distance error function changed to match changes in RANSAC

function [bestInliers, bestF] = funddist(F, x, t);
    
    x1 = x(1:3,:);    % Extract x1 and x2 from x
    x2 = x(4:6,:);
    
    
    if iscell(F)  % We have several solutions each of which must be tested
		  
        nF = length(F);   % Number of solutions to test
        bestF = F{1};     % Initial allocation of best solution
        ninliers = 0;     % Number of inliers
        
        for k = 1:nF
            d = fdist(F{k}, x1, x2);
            inliers = find(abs(d) < t);     % Indices of inlying points
            
            if length(inliers) > ninliers   % Record best solution
                ninliers = length(inliers);
                bestF = F{k};
                bestInliers = inliers;
            end
        end
        
    else     % We just have one solution
        d = fdist(F, x1, x2);

        bestInliers = find(abs(d) < t);     % Indices of inlying points
        bestF = F;                          % Copy F directly to bestF
    end
end

function d = fdist(F, x1, x2)
    x2tFx1 = zeros(1,length(x1));
    for n = 1:length(x1)
        x2tFx1(n) = x2(:,n)'*F*x1(:,n);
    end

    Fx1 = F*x1;
    Ftx2 = F'*x2;     
    
    % Evaluate distances
    d =  x2tFx1.^2 ./ ...
         (Fx1(1,:).^2 + Fx1(2,:).^2 + Ftx2(1,:).^2 + Ftx2(2,:).^2);
end
