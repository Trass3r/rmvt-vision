function showcam(c, T, P)

    if nargin < 2
        T = c.Tcam
    end

    daspect([1 1 1])
    hold on
    [xs,ys,zs] = sphere(20);

    % transform the sphere
    xyz = transformp(T, [xs(:)'; ys(:)'; zs(:)']);
    x = reshape(xyz(1,:), size(xs));
    y = reshape(xyz(2,:), size(xs));
    z = reshape(xyz(3,:), size(xs));
            
    surf(x,y,z, 'FaceColor', 'w', 'EdgeColor', 0.95*[1 1 1])
    A = 1.6;
    o = transformp(T, [0 0 0]');
    ax = transformp(T, [A 0 0]');
    arrow3(o', ax'); text(ax(1), ax(2), ax(3), ' X')
    ax = transformp(T, [0 A 0]');
    arrow3(o', ax'); text(ax(1), ax(2), ax(3), ' Y')
    ax = transformp(T, [0 0 A]');
    arrow3(o', ax'); text(ax(1), ax(2), ax(3), ' Z')

    %grid off
    %set(gcf, 'Color', 'w');
    %set(gca,'Xcolor', 'w')
    %set(gca,'Ycolor', 'w')
    %set(gca,'Zcolor', 'w')
    %view(120, 30);

    if nargin > 1
        for i=1:numcols(P)
            plot3([o(1) P(1,i)], [o(2) P(2,i)], [o(3) P(3,i)], 'r');
        end
    end
    hold off
