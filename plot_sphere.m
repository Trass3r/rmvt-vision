function h = plot_sphere(c, r, color)

    daspect([1 1 1])
    hold_on = ishold
    hold on
    [xs,ys,zs] = sphere(20);

    if length(r) == 1
        r = r * ones(numcols(c),1);
    end

    % transform the sphere
    for i=1:numcols(c)
        x = r(i)*xs + c(1,i);
        y = r(i)*ys + c(2,i);
        z = r(i)*zs + c(3,i);
                
        h = surf(x,y,z, 'FaceColor', color, 'EdgeColor', 'none')
        % the following displays a nice smooth grey sphere with glint!
        % need a linear color map
        % not sure how to make it a different color
        % camera patches disappear when shading interp is on
        %h = surfl(x,y,z)
    end
    if ~hold_on
        hold off
    end
