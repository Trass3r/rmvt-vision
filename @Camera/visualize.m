%SHOWCAMERA Display a camera icon in 3D
%
%   c.showcamera(T)
%
%  Create a new camera at pose T, and return the graphics handle.
%
% The camera is depicted as a pyramid with the apex as the camera
% origin and the base plane normal to the optical axis.
% The sides are colored red, green, blue corresponding to the X, Y, Z axes
% respectively.


function h = visualize(c, varargin)

    opt.scale = [];
    opt.square = false;

    [opt,arglist] = tb_optparse(opt, varargin);

    % this create a new figure!!
    %ish = ishold;
    ish = 0;
    
    % do the axis/figure logic

    if isempty(c.h_visualize) || ~ishandle(c.h_visualize)
        disp('creating new figure for visualization')
        if ~ish
            clf
        end
        h = axes
        disp('make axes');
    else
        disp('using existing visualization');
        h = c.h_visualize;
        return;
    end

    % generate graphics for a new camera
    fig = get(h, 'Parent');
    set(fig, 'Tag', 'visualize');
    set(fig, 'name', class(c));
    c.h_visualize = h;       % keep this around

    % draw the camera

    P = [];
    if ~isempty(arglist)
        % some points were given
        P = arglist{1};
        if ~isnumeric(P) || numrows(P) ~= 3
            error('bad format for world points');
        end

        limits = P';
    else
        limits = [];
    end

    limits = [limits; transl(c.T)'];

    mn = min(limits);
    mx = max(limits);
    middle = mean(limits);
    
    margin = 1.2;
    mx = middle + margin*(mx-middle);
    mn = middle - margin*(middle-mn);

    maxdim = max(mx-mn);
    if maxdim == 0
        maxdim = 1;
    end

    c.h_camera3D = c.drawCamera(maxdim*0.4, arglist{:});
    set(c.h_camera3D, 'Matrix', c.T);

    if ~isempty(P)
        plot_sphere(P, maxdim*0.03, 'r');
    end

    c.P = P;
    set(h, 'DataAspectRatioMode', 'manual');
    set(h, 'DataAspectRatio', [1 1 1]);
    grid on
    xyzlabel
    rotate3d on
    title(c.name);
    figure(fig);   % raise the camera view


    if ~ish
        %hold off
    end
    set(fig, 'HandleVisibility', 'off');
end
