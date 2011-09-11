%RegionFeature Region feature class
%
% This class represents a region feature.
%
% Methods::
% boundary        Return the boundary as a list
% box             Return the bounding box
% plot            Plot the centroid
% plot_boundary   Plot the boundary
% plot_box        Plot the bounding box
% plot_ellipse    Plot the equivalent ellipse
% display         Display value
% char            Convert value to string
%
% Properties::
%  uc            centroid, horizontal coordinate
%  vc            centroid, vertical coordinate
%  umin          bounding box, minimum horizontal coordinate
%  umax          bounding box, maximum horizontal coordinate
%  vmin          bounding box, minimum vertical coordinate
%  vmax          bounding box, maximum vertical coordinate
%  area          the number of pixels
%  class         the value of the pixels forming this region
%  label         the label assigned to this region
%  children      a list of indices of features that are children of this feature
%  edgepoint     coordinate of a point on the perimeter
%  edge          a list of edge points 2xN matrix
%  perimeter     number of edge pixels
%  touch         true if region touches edge of the image
%  a             major axis length of equivalent ellipse
%  b             minor axis length of equivalent ellipse
%  theta         angle of major ellipse axis to horizontal axis
%  shape         aspect ratio b/a (always <= 1.0)
%  circularity   1 for a circle, less for other shapes
%  moments       a structure containing moments of order 0 to 2
%
% Note::
%  - RegionFeature is a reference object.
%  - RegionFeature objects can be used in vectors and arrays
%  - This class behaves differently to LineFeature and PointFeature when
%    getting properties of a vector of RegionFeature objects.  For example
%    R.uc will be a list not a vector.
%    
% See also IBLOBS, IMOMENTS.

% TODO:
% make property of object vector like Line/PointFeature


% Copyright (C) 1993-2011, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
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
        %RegionFeature.RegionFeature Create a region feature object
        %
        % R = RegionFeature() is a region feature object with null parameters.

            b.area = [];
            b.label = [];
            b.edge = [];
        end

        function display(b)
        %RegionFeature.display Display value
        %
        % R.display() is a compact string representation of the region feature.
        % If R is a vector then the elements are printed one per line.
        %
        % Notes::
        % - this method is invoked implicitly at the command line when the result
        %   of an expression is a RegionFeature object and the command has no trailing
        %   semicolon.
        %
        % See also RegionFeature.char.


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
        %RegionFeature.char Convert to string
        %
        % S = R.char() is a compact string representation of the region feature.
        % If R is a vector then the string has multiple lines, one per element.

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
        %RegionFeature.box Return bounding box
        %
        % B = R.box() is the bounding box in standard Toolbox form [xmin,xmax; ymin, ymax].
            b = [bb.umin bb.umax; bb.vmin bb.vmax];
        end

        function plot_boundary(bb, varargin)
        %RegionFeature.plot_boundary Plot boundary
        %
        % R.plot_boundary() overlay perimeter points on current plot.
        %
        % R.plot_boundary(LS) as above but the optional line style arguments LS are
        % passed to plot.
        %
        % Notes::
        % - If R is a vector then each element is plotted.
        %
        % See also BOUNDMATCH.

            holdon = ishold;
            hold on
            for b=bb
                plot(b.edge(1,:), b.edge(2,:), varargin{:});
            end
            if ~holdon
                hold off
            end
        end

        function plot(bb, varargin)
        %RegionFeature.plot Plot centroid
        %
        % R.plot() overlay the centroid on current plot.  It is indicated with 
        % overlaid o- and x-markers.
        %
        % R.plot(LS) as above but the optional line style arguments LS are
        % passed to plot.
        %
        % If R is a vector then each element is plotted.
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
        %RegionFeature.plot_box Plot bounding box
        %
        % R.plot_box() overlay the the bounding box of the region on current plot.
        %
        % R.plot_box(LS) as above but the optional line style arguments LS are
        % passed to plot.
        %
        % If R is a vector then each element is plotted.
            for b=bb
                plot_box(b.umin, b.vmin, b.umax, b.vmax, varargin{:});
            end
        end

        function plot_ellipse(bb, varargin)
        %RegionFeature.plot_ellipse Plot equivalent ellipse
        %
        % R.plot_ellipse() overlay the the equivalent ellipse of the region on current plot.
        %
        % R.plot_ellipse(LS) as above but the optional line style arguments LS are
        % passed to plot.
        %
        % If R is a vector then each element is plotted.
            for b=bb
                J = [b.moments.u20 b.moments.u11; b.moments.u11 b.moments.u02];
                plot_ellipse(4*J/b.moments.m00, [b.uc, b.vc], varargin{:});
            end
        end
        
        function [ri,thi] = boundary(f, varargin)
        %RegionFeature.boundary Boundary in polar form
        %
        % [D,TH] = R.boundary() is a polar representation of the boundary with
        % respect to the centroid.  D(i) and TH(i) are the distance to the boundary
        % point and the angle respectively.  These vectors have 400 elements
        % irrespective of region size.

            dxy = bsxfun(@minus, f.edge, [f.uc f.vc]');

            r = norm2(dxy)';
            th = -atan2(dxy(2,:), dxy(1,:));
            [th,k] = sort(th, 'ascend');
            r = r(k);

            if nargout == 0
                plot(dxy(1,:), dxy(2,:), varargin{:});

            else
                thi = [0:399]'/400*2*pi - pi;
                ri = interp1(th, r, thi, 'spline');
            end
        end
    end

end
