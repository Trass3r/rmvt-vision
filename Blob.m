

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
classdef Blob < handle
    properties
        area
        xc       % centroid
        yc
        
        minx        % the bounding box
        maxx
        miny
        maxy

        color       % the class of the pixel in the original image
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

        function b = Blob(b)
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
                        bi.area, bi.xc, bi.yc, bi.theta, bi.shape);
                elseif ~isempty(bi.edge)
                    s = sprintf('[%d] area=%d, cent=(%.1f,%.1f), theta=%.2f, a/b=%.3f, color=%d, touch=%d, parent=%d, perim=%d, circ=%.3f', ... 
                        bi.label, bi.area, bi.xc, bi.yc, bi.theta, bi.shape, bi.color, bi.touch, ...
                        bi.parent, bi.perimeter, bi.circularity);
                else
                    s = sprintf('[%d] area=%d, cent=(%.1f,%.1f), theta=%.2f, a/b=%.3f, color=%d, touch=%d, parent=%d', ... 
                        bi.label, bi.area, bi.xc, bi.yc, bi.theta, bi.shape, bi.color, bi.touch, bi.parent);
                end
                ss = strvcat(ss, s);
            end
        end

        function plot_boundary(bb, varargin)
            holdon = ishold
            hold on
            for b=bb
                plot(b.edge(:,1), b.edge(:,2), varargin{:});
            end
            if ~holdon
                hold off
            end
        end

        function plot_centroid(bb, varargin)
            for b=bb
                markfeatures([b.xc b.yc], 0, varargin{:});
            end
        end

        function plot_box(bb, varargin)
            for b=bb
                plot_box(b.minx, b.miny, b.maxx, b.maxy, varargin{:});
            end
        end

        function plot_ellipse(bb, varargin)
            for b=bb
                J = [b.moments.u20 b.moments.u11; b.moments.u11 b.moments.u02];
                plot_ellipse(4*J/b.moments.m00, [b.uc, b.vc], varargin{:});
            end
        end

    end

end
