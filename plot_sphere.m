%PLOT_SPHERE Plot spheres
%
%   h = plot_sphere(c, r, color)
%   h = plot_sphere(c, r, color, alpha)
%
% Adds spheres to the current figure.  c is the centre of the sphere
% and if its a 3xN matrix then N spheres are drawn with centres as per
% the columns.  r is the radius and color is a Matlab color spec, either
% a letter or 3-vector.
%
% The optional parameter alpha controls the opacity, 0 is transparant and 1
% is opaque.  The default is 1.
%
% NOTES:
% The sphere is always added, irrespective of figure hold state.
% The graphics handle is returned.
% The number of vertices to draw the sphere is hardwired.

function h = plot_sphere(c, r, color, alpha)

    daspect([1 1 1])
    hold_on = ishold
    hold on
    [xs,ys,zs] = sphere(40);

    if length(c) == 3
        c = c(:);
    end
    if length(r) == 1
        r = r * ones(numcols(c),1);
    end

    if nargin < 4
        alpha = 1
    end

    % transform the sphere
    for i=1:numcols(c)
        x = r(i)*xs + c(1,i);
        y = r(i)*ys + c(2,i);
        z = r(i)*zs + c(3,i);
                
        h = surf(x,y,z, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', alpha)
        % the following displays a nice smooth grey sphere with glint!
        % need a linear color map
        % not sure how to make it a different color
        % camera patches disappear when shading interp is on
        %h = surfl(x,y,z)
    end
    lighting gouraud
    light
    if ~hold_on
        hold off
    end
