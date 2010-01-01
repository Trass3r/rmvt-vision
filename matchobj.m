%MATCH

classdef matchobj < handle

    properties
        xy          % x1 y1 x2 y2 of corresponding points
        strength    % strength of match
        image1      % first image
        image2      % second image
        in
    end

    methods

        function help(m)
            disp('matchobj class:');
            disp('  m           display summary info about matches')
            disp('  m.length    number of matches')
            disp('  m.inliers   coordinates of inliers: u1 v1 u2 v2')
            disp('  m.outliers  coordinates of outliers: u1 v1 u2 v2')
            disp('  m.plot      display two source images side by side and overlay matches')
            disp('  m.plot(''all'')      " " show all matches (default)')
            disp('  m.plot(''in'')       " " only show inliers')
            disp('  m.plot(''out'')      " " only show outliers')
            disp('  m.plot(''only'', n)  " " only show n matches')
            disp('  m.plot(''first'', n) " " only show first n matches')
            disp('  m.plot(ls)         " " with specified line style')
            disp('    eg. m.plot(''out'', ''only'', 50, ''r'')  show only 50 outliers as red lines')
        end

        function v = length(m)
            v = numrows(xy);
        end

        function v = inliers(m)
            if isempty(m.in)
                v = [1:numrows(m.xy)];
            end
            v = m.in;
        end

        function v = outliers(m)
            v = setdiff([1:numrows(m.xy)], m.in);
        end
        
        function display(m)
            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            disp( char(m) );
        end % display()

        function s = char(m)
            s = sprintf('%d matches\n', numrows(m.xy));
            if isempty(m.in)
                s = [s sprintf('no inliers\n')];
            else                
                s = [s sprintf('%d inliers\n', length(m.in))];
                s = [s sprintf('%d outliers\n', numrows(m.xy) - length(m.in))];
            end
        end
        
        function plot(m, varargin)

            h = numrows(m.image1);
            sep = 10;
            
            xy = m.xy;
            k = 1;
            while k<=length(varargin)
                switch varargin{k}
                    case 'first'
                        n = varargin{k+1};
                        k = k + 1;
                        xy = xy(1:n,:);
                    case 'only'
                        n = varargin{k+1};
                        k = k + 1;
                        skip = round(numrows(xy) / n);
                        xy = xy(1:skip:end,:);
                    case 'all'
                        xy = m.xy;
                    case 'out'
                        xy = m.xy(m.outliers,:);
                    case 'in'
                        xy = m.xy(m.in,:);
                    otherwise
                        varargin = varargin(k:end);
                        break;
                end
                k = k + 1;
            end
            varargin

            im = zeros( max(size(m.image1,1), size(m.image2,1)), ...
                size(m.image1,2)+size(m.image2,2)+sep);
            im = ipaste(im, m.image1, [1,1]);
            im = ipaste(im, m.image2, [size(m.image1,2)+sep,1]);
            idisp(im, 'nogui');
            w = sep + numcols(m.image1);

            hold on
            for k=1:numrows(xy),
                plot([xy(k,1) xy(k,3)+w], xy(k,[2 4]), varargin{:});
            end
            hold off
            figure(gcf);
        end % plot
        
        function M = ransac(m, func, varargin)
            [M, m.in, r] = ransac(func, m.xy', varargin{:});
            r
        end
    end

end
