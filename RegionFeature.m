classdef RegionFeature < handle
    properties
        area
        uc       % centroid
        vc
        
        umin        % the bounding box
        umax
        vmin
        vmax

        class       % the class of the pixel in the original image
        label       % the label assigned to this region
        parent      % the label of this region's parent
        children    % a list of features that are children of this feature
        edgepoint   % (x,y) of a point on the perimeter
        edge        % list of edge points
        perimeter   % length of edge
        touch       % 0 if it doesnt touch the edge, 1 if it does

        % equivalent ellipse parameters
        a           % the major axis length
        b           % the minor axis length  b<a
        theta       % angle of major axis with respect to horizontal
        shape       % b/a  < 1.0
        circularity

        moments     % moments, a struct of: m00, m01, m10, m02, m20, m11
    end

    methods

        function b = RegionFeature(b)
            b.area = [];
            b.label = [];
            b.edge = [];
        end

        function display(b)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(b))
            if loose
                disp(' ');
            end
        end

        function ss = char(b)
            ss = '';
            for i=1:length(b)
                bi = b(i);
                if isempty(bi.area)
                    s = '[]';
                elseif isempty(bi.label)
                    s = sprintf('area=%d, cent=(%.1f,%.1f), theta=%.2f, a/b=%.3f', ...
                        bi.area, bi.uc, bi.vc, bi.theta, bi.shape);
                elseif ~isempty(bi.edge)
                    s = sprintf('(%d) area=%d, cent=(%.1f,%.1f), theta=%.2f, a/b=%.3f, class=%d, label=%d, touch=%d, parent=%d, perim=%d, circ=%.3f', ... 
                        i, bi.area, bi.uc, bi.vc, bi.theta, bi.shape, bi.class, bi.label, ...
                        bi.touch, bi.parent, bi.perimeter, bi.circularity);
                else
                    s = sprintf('(%d) area=%d, cent=(%.1f,%.1f), theta=%.2f, a/b=%.3f, color=%d, label=%d, touch=%d, parent=%d', ... 
                        i, bi.area, bi.uc, bi.vc, bi.theta, bi.shape, bi.class, bi.label, ...
                        bi.touch, bi.parent);

                end
                ss = strvcat(ss, s);
            end
        end

        function b = box(bb)
            b = [bb.umin bb.umax; bb.vmin bb.vmax];
        end

        function plot_boundary(bb, varargin)
            holdon = ishold;
            hold on
            for b=bb
                plot(b.edge(:,1), b.edge(:,2), varargin{:});
            end
            if ~holdon
                hold off
            end
        end

        function plot(bb, varargin)
            holdon = ishold;
            hold on
            for b=bb
                %% TODO: mark with x and o, dont use markfeatures
                %markfeatures([b.uc b.uc], 0, varargin{:});
                if isempty(varargin)
                    plot(b.uc, b.vc, 'go');
                    plot(b.uc, b.vc, 'gx');
                else
                    plot(b.uc, b.vc, varargin{:})
                end

            end
            if ~holdon
                hold off
            end
        end

        function plot_box(bb, varargin)
            for b=bb
                plot_box(b.umin, b.vmin, b.umax, b.vmax, varargin{:});
            end
        end

        function plot_ellipse(bb, varargin)
            for b=bb
                I = [b.moments.u20 b.moments.u11; b.moments.u11 b.moments.u02];
                plot_ellipse([b.xc, b.yc], sqrtm(I), varargin{:});
            end
        end
        
        function [ri,thi] = boundary(f, varargin)

            dxy = f.edge - ones(numrows(f.edge),1)*[f.uc f.vc];

            r = norm2(dxy')';
            th = -atan2(dxy(:,2), dxy(:,1));
            [th,k] = sort(th, 'ascend');
            r = r(k);

            if nargout == 0
                plot(dxy(:,1), dxy(:,2), varargin{:});

            else
                thi = [0:399]'/400*2*pi - pi;
                ri = interp1(th, r, thi, 'spline');
            end
        end
    end

end
