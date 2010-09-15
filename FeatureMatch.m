%FeatureMatch
% 
% m           display summary info about matches
% m.length    number of matches
% m.inliers   coordinates of inliers: u1 v1 u2 v2
% m.outliers  coordinates of outliers: u1 v1 u2 v2
% m.plot      display two source images side by side and overlay matches
% m.plot(''all'')      " " show all matches (default)
% m.plot(''in'')       " " only show inliers
% m.plot(''out'')      " " only show outliers
% m.plot(''only'', n)  " " only show n matches
% m.plot(''first'', n) " " only show first n matches
% m.plot(ls)         " " with specified line style
% eg. m.plot(''out'', ''only'', 50, ''r'')  show only 50 outliers as red lines

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
            if nargin == 0
                return;
            end

            m.xy_ = [f1.u_ f1.v_ f2.u_ f2.v_]';
            m.distance_ = s;
            m.inlier_ = NaN;
        end

        function v = inlier(m)
            v = m([m.inlier_] == true);
        end

        function v = outlier(m)
            v = m([m.inlier_] == false);
        end

        function v = distance(m)
            v = [m.distance_];
        end

        function display(m)
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
            s = sprintf('%d corresponding points\n', length(m));
            in = [m.inlier_];
            s = [s sprintf('%d inliers\n', sum(in==true))];
            s = [s sprintf('%d outliers\n', sum(in==false)) ];
        end
        
        function v = subset(m, n)
            i = round(linspace(1, length(m), n));
            v = m(i);
        end

        function s = p1(m, k)
            xy = [m.xy_];
            s = xy(1:2,:);
        end
        
        function s = p2(m, k)
            xy = [m.xy_];
            s = xy(3:4,:);
        end
        
        function s = p(m, k)
            s = [m.xy_];
        end
        
        function plot(m, varargin)       

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
