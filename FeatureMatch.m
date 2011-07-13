%FeatureMatch Feature match object
%
% This class represents a point feature correspondence.
%
% Methods::
% show
% plot
%
% ransac     Determine inliers and outliers
% inlier     Return inlier matches
% outlier    Return outlier matches
% subset     Return a subset of matches
% p          Set of corresponding points
% p1         Points in view 1
% p2         Points in view 2
% display    Display value of match
% char       Convert value of match to string
% 
% Note::
%  - FeatureMatch is a reference object.
%  - FeatureMatch objects can be used in vectors and arrays
%
% See also PointFeature, SurfPointFeature, SiftPointFeature.



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

classdef FeatureMatch < handle

    properties
        xy_          % x1 y1 x2 y2 of corresponding points
        distance_    % strength of match
        inlier_      % NaN indeterminate
                    % true inlier
                    % false outlier
    end

    methods

        function m = FeatureMatch(f1, f2, s)
        %FeatureMatch.FeatureMatch Create a new FeatureMatch object
        %
        % M = FeatureMatch(F1, F2, S) is a new FeatureMatch object describing a 
        % correspondence between point features F1 and F2 with a strength of S.
        %
        % See also PointFeature, SurfPointFeature, SiftPointFeature.

            if nargin == 0
                m.xy_ = [];
                m.distance_ = [];
                m.inlier_ = [];
                return;
            end

            m.xy_ = [f1.u_ f1.v_ f2.u_ f2.v_]';
            m.distance_ = s;
            m.inlier_ = NaN;
        end

        function v = inlier(m)
        %FeatureMatch.inlier Return all inlier features
        %
        % M2 = M.inlier() returns a subset of the FeatureMatch vector M that are
        % considered to be inliers.
        %
        % See also FeatureMatch.outlier.
            v = m([m.inlier_] == true);
        end

        function v = outlier(m)
        %FeatureMatch.outlier Return all outlier features
        %
        % M2 = M.outlier() returns a subset of the FeatureMatch vector M that are
        % considered to be outliers.
        %
        % See also FeatureMatch.inlier.
            v = m([m.inlier_] == false);
        end

        function v = distance(m)
            v = [m.distance_];
        end

        function display(m)
        %FeatureMatch.display Display the value of a match
        %
        % M.display() is a compact string representation of the match feature.
        % If M is a vector then the elements are printed one per line.
        %
        % Notes::
        % - this method is invoked implicitly at the command line when the result
        %   of an expression is a FeatureMatch object and the command has no trailing
        %   semicolon.
        %
        % See also FeatureMatch.char.

            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            if length(m) > 20
                fprintf('%d corresponding points (listing suppressed)\n', length(m));
            else
                disp( char(m) );
            end
        end % display()

        function s = char(matches)
        %FeatureMatch.char Create string representation of a match
        %
        % S = M.char() is a compact string representation of the match object.
        % If M is a vector then the string has multiple lines, one per element.

            s = '';
            for m=matches
                ss = sprintf('(%g, %g) <-> (%g, %g), dist=%f', ...
                    m.xy_, m.distance_);
                switch m.inlier_
                case true
                    ss = [ss ' +'];
                case false
                    ss = [ss ' -'];
                end
                s = strvcat(s, ss);
            end
        end
        
        function s = show(m)
        %FeatureMatch.show Display summary statistics of the FeatureMatch vector
        %
        % M.show() is a compact summary of the FeatureMatch vector M that gives
        % the number of matches, inliers and outliers (and their percentages).
            s = sprintf('%d corresponding points\n', length(m));
            in = [m.inlier_];
            s = [s sprintf('%d inliers (%.1f%%)\n', ...
                sum(in==true), sum(in==true)/length(m)*100)];
            s = [s sprintf('%d outliers (%.1f%%)\n', ...
                sum(in==false), sum(in==false)/length(m)*100) ];
        end
        
        function v = subset(m, n)
        %FeatureMatch.subset Return a subset of matches
        %
        % M2 = M.subset(N) returns a FeatureMatch vector with no more than N elements
        % sampled uniformly from M.
            i = round(linspace(1, length(m), n));
            v = m(i);
        end

        function s = p1(m, k)
        %FeatureMatch.p1 Return  point coordinates
        %
        % P = M.p1() is a 2xN matrix containing the feature points coordinates
        % from view 1.  These are the (u,v) properties of the feature F1 passed
        % to the constructor.
        %
        % See also FeatureMatch.FeatureMatch, FeatureMatch.p2, FeatureMatch.p.
            xy = [m.xy_];
            s = xy(1:2,:);
        end
        
        function s = p2(m, k)
        %FeatureMatch.p2 Return  point coordinates
        %
        % P = M.p2() is a 2xN matrix containing the feature points coordinates
        % from view 1.  These are the (u,v) properties of the feature F2 passed
        % to the constructor.
        %
        % See also FeatureMatch.FeatureMatch, FeatureMatch.p1, FeatureMatch.p.

            xy = [m.xy_];
            xy = [m.xy_];
            s = xy(3:4,:);
        end
        
        function s = p(m, k)
        %FeatureMatch.p Return  point coordinates
        %
        % P = M.p() is a 4xN matrix containing the feature points.  Each column
        % contains the coordinates of a pair of corresponding points [u1,v1,u2,v2].
        %
        % See also FeatureMatch.p1, FeatureMatch.p2.
            s = [m.xy_];
        end
        
        function plot(m, varargin)       
        %FeatureMatch.plot Overlay correspondences
        %
        % M.plot() overlays the correspondences in the FeatureMatch vector M
        % on the current figure.  The figure must be of two images as created
        % by passing a cell array of two images to idisp(), eg.
        %
        %      idisp({im1,im2})
        %      m.plot()
        %
        % M.plot(LS) as above but the optional line style arguments LS are
        % passed to plot.
        %
        % See also idisp.

            try
                ud = get(gca, 'UserData');
                u0 = ud.u0;
            catch
                error('Current image is not a pair displayed by idisp');
            end
            w = u0(2);
            
            xy = [m.xy_];
            hold on
            for k=1:numcols(xy),
                plot([xy(1,k) xy(3,k)+w], xy([2 4],k), varargin{:});
            end
            hold off
            figure(gcf);
        end % plot
        
        function [MM,rr] = ransac(m, func, varargin)
        %FeatureMatch.ransac Apply RANSAC
        %
        % M.ransac(FUNC, OPTIONS) applies the RANSAC algorithm to fit the point
        % correspondences to the function FUNC.  The OPTIONS are passed to the
        % ransac function.  Elements of the FeatureMatch vector have their
        % status updated in place to indicate whether they are inliers or outliers.
        %
        % See also FMATRIX, HOMOGRAPHY, RANSAC.
            [M,in,resid] = ransac(func, [m.xy_], varargin{:});
            
            % mark all as outliers
            for i=1:length(m)
                m(i).inlier_ = false;
            end
            for i=in
                m(i).inlier_ = true;
            end

            if nargout >= 1
                MM = M;
            end
            if nargout >= 2
                rr = resid;
            end
        end
    end

end
