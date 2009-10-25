% Based on code by Pascal Getreuer 2006
% Demo for colorspace.m - the CIE xyY "tongue"

function [im,ax,ay] = xycolorspace(cxy)
    N = 160;
    Nx = round(N*0.8);
    Ny = round(N*0.9);
    e = 0.01;
    % Generate colors in the xyY color space
    x = linspace(e,0.8-e,Nx);
    y = linspace(e,0.9-e,Ny);
    [xx,yy] = meshgrid(x,y);
    iyy = 1./(yy + 1e-5*(yy == 0));

    % Convert from xyY to XYZ
    Y = ones(Ny,Nx);
    X = Y.*xx.*iyy;
    Z = Y.*(1-xx-yy).*iyy;
    % Convert from XYZ to R'G'B'
    CIEColor = colorspace('rgb<-xyz',cat(3,X,Y,Z));


    % define the boundary
    lambda = [400:20:700]*1e-9';
    xyz = ccxyz(lambda);

    xy = xyz(:,1:2);

    % Make a smooth boundary with spline interpolation
    xi = [interp1(xy(:,1),1:0.25:size(xy,1),'spline'),xy(1,1)];
    yi = [interp1(xy(:,2),1:0.25:size(xy,1),'spline'),xy(1,2)];

    % create a mask image, colors within the boundary
    in = inpolygon(xx, yy, xi,yi);
    
    CIEColor(~cat(3,in,in,in)) = 1; % set outside pixels to white

    if nargout == 0,
        % Render the colors on the tongue
        image(x,y,CIEColor)
        if nargin == 1
            markfeatures(cxy, 0, '*', {10, 'k'});
        end
    
        set(gca, 'Ydir', 'normal');

        hold on
        plot(xi,yi,'k-');
%         for lambda = 400:20:700,
%             xyz = ccxyz(lambda*1e-9);
%             plot(xyz(1), xyz(2), 'Marker', 'o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
%         end
        hold off
        
        axis([0,0.8,0,0.9]);
        xlabel('x');
        ylabel('y');
        grid
        shg;
    else
        ax = x;
        ay = y;
        im = CIEColor;
        if nargin == 1
            markfeatures(cxy, 0, '*', {10, 'k'});
        end
    
    end
