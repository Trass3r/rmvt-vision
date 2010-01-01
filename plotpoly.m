%PLOTPOLY Plot a polygon
%
%   plotpoly(p, args)
%
% p is 2D or 3D point data, one row per point.

% TODO: options for fill, not filled, line style, labels (cell array of strings)

function plotpoly(p, varargin)

    if numrows(p) < 3,
        error('too few points for a polygon');
    end

    x = [p(:,1); p(1,1)];
    y = [p(:,2); p(1,2)];
    if numcols(p) == 2,
        plot(x, y, varargin{:});
        % h = patch(x,y,0*y)
        %set(h, 'FaceColor', varargin{1}(1))
        %set(h, 'FaceAlpha', 0.5);
    elseif numcols(p) == 3,
        z = [p(:,3); p(1,3)];
        plot3(x, y, z, varargin{:});
    else
        error('point data must have 2 or 3 columns');
    end
