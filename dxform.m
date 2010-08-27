%DISTANCEXFORM Distance transform of occupancy grid
%
%   dist = distancexform(world, goal)
%
%   Compute the distance transform for the occupancy grid, world, with
%  respect to the specified goal point (x,y).
%
%   dist = distancexform(world, goal, metric)
%
%  Specify the metric, either 'cityblock' or 'Euclidean'
%
%   dist = distancexform(world, goal, metric, show)
%
% Show an animation of the distance transform being formed, with a delay
% of show seconds between frames.

function d = distancexform(world, metric, show)
    
    if nargin < 3
        show = 0;
    end

    % set up the distance metrics
    if nargin < 2
        metric = 'cityblock';
    end

    if strncmpi(metric, 'cityblock', length(metric))
        m = ones(3,3);
        m(2,2) = 0;
    elseif strncmpi(metric, 'euclidean', length(metric))
        r2 = sqrt(2);
        m = [r2 1 r2; 1 0 1; r2 1 r2];
    else
        error('unknown distance metric');
    end

    world(world==0) = Inf;
    world(world==1) = 0;

    count = 0;
    while 1,
        world = imorph(world, m, 'plusmin');
        count = count+1;
        if show
            cmap = gray(256);
            cmap = [1 0 0; cmap];
            colormap(cmap)
            image(world+1, 'CDataMapping', 'direct');
            set(gca, 'Ydir', 'normal');
            xlabel('x');
            ylabel('y');
            pause(show);
        end

        if length(find(world(:)==Inf)) == 0
            break;
        end
    end

    if show
        fprintf('%d iterations\n', count);
    end

    d = world;
