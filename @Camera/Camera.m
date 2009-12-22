%Camera  Camera superclass
%
% Abstract superclass for Toolbox Camera classes.
%
%   The camera coordinate system is:
%
%       0------------> u X
%       |
%       |
%       |   + (principal point)
%       |
%       |
%       v Y
%
% Object properties (read/write)
%
%   C.s           intrinsic: pixel size 2x1
%   C.pp          intrinsic: principal point 2x1
%   C.np          size of the virtual image plane (pixels) 2x1
%
%   C.Tcam        extrinsic: pose of the camera
%   C.name        name of the camera, used for graphical display
%
% Object properties (read only)
%
%   C.su          pixel width
%   C.sv          pixel height
%   C.u0          principal point, u coordinate
%   C.v0          principal point, v coordinate
% 
% Object methods
%
%   C.fov         return camera half field-of-view angles (2x1 rads)
%   C.K           return camera intrinsic matrix (3x3)
%   C.P           return camera project matrix for camera pose (3x4)
%   C.P(T)        return camera intrinsic matrix for specified camera pose (3x4)
%
%   C.H(T, n, d)  return homography for plane: normal n, distance d  (3x3)
%   C.F(T)        return fundamental matrix from pose 3x3
%   C.E(T)        return essential matrix from pose 3x3
%   C.E(F)        return essential matrix from fundamental matrix 3x3
%
%   C.invH(H)     return solutions for camera motion and plane normal
%   C.invE(E)     return solutions for pose from essential matrix 4x4x4
%
%   C.rpy(r,p,y)   set camera rpy angles
%   C.rpy(rpy)
%
%   uv = C.project(P)       return image coordinates for world points  P
%   uv = C.project(P, T)    return image coordinates for world points P transformed by T
%
%  P is a list of 3D world points and the corresponding image plane points are returned in uv.
% If P has 3 columns it is treated as a number of 3D points in  world coordinates, one point per row.
% If POINTS has 6 columns, each row is treated as the start and end 3D coordinate for a line segment,
% in world coordinates.  
%
% The optional arguments, T, represents a transformation that can be applied
% to the object data, P, prior to 'imaging'.  The camera pose, C.Tcam, is also 
% taken into account.
%
%   uv = C.plot(P)          display image coordinates for world points P
%   uv = C.plot(P, T)       display image coordinates for world points P transformed by T
%
% Points are displayed as a round marker.  Lines are displayed as line segments.
% Optionally returns image plane coordinates uv.
%
%   C.create
%   C.create(name)
%
%   Create a graphical camera with name, and pixel dimensions given by C.npix.  Automatically
%  called on first call to plot().

% Copyright (C) 1995-2009, by Peter I. Corke
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

% TODO:
%   make a parent imaging class and subclass perspective, fisheye, panocam
%   test for points in front of camera and set to NaN if not
%   test for points off the image plane and set to NaN if not
%     make clipping/test flags
classdef Camera < handle

    properties
        name    % camera name
        type
        s       % pixel dimensions 1x2
        pp      % principal point 1x2
        npix    % number of pixel 1x2
        Tcam    % camera pose
        noise   % pixel noise 1x2
    end

    properties (SetAccess = protected)
        handle
        limits
        perspective
        h_show % handle for camera view
        h_plot % handle for image plane
    end

    properties (GetAccess = protected, SetAccess = protected)

    end

    properties (GetAccess = private)
    end

    properties (Dependent = true, SetAccess = protected)
        u0
        v0
        su
        sv
        nu
        nv
    end
    
    methods

        %
        %   Return a camera intrinsic parameter structure:
        %       focal length 8mm
        %       pixel size 10um square
        %       image size 1024 x 1024
        %       principal point (512, 512)
        function c = Camera(varargin)

            % default values
            c.type = '**abstract**';
            c.Tcam = eye(4,4);
            c.s = [1 1];
            c.pp = [];
            c.limits = [-1 1 -1 1];
            c.npix = [];
            c.noise = [];
            c.name = 'unnamed';
            c.perspective = false;
            c.h_plot = [];
            c.h_show = [];


            if nargin == 0,
                c.name = 'canonic';
                c.pp = [0 0];
            else
                c.name = 'noname';

                count = 1;
                args = varargin{:};
                while count <= length(args)
                    switch lower(args{count})
                    case 'name'
                        c.name = args{count+1}; count = count+1;
                    case 'resolution'
                        v = args{count+1}; count = count+1;
                        if length(v) == 1
                            v = [v v];
                        end
                        c.npix = v;
                    case 'centre'
                        c.pp = args{count+1}; count = count+1;
                    case 'pixel'
                        s = args{count+1}; count = count+1;
                        c.s = s;
                    case 'noise'
                        v = args{count+1}; count = count+1;
                        if length(v) == 1
                            v = [v v];
                        end
                        c.noise = v;
                    case 'pose'
                        c.Tcam = args{count+1}; count = count+1;
                    otherwise
                        % if the parameter is not known by the base class, call
                        % the parameter handler in the derived class.
                        % it returns the number of additonal parameters consumed.
                        n = c.paramSet(args(count:end));
                        count = count + n;
                    end
                    count = count + 1;
                end
                if isempty(c.pp)
                    fprintf('principal point not specified, setting it to centre of image plane\n');
                    c.pp = c.npix / 2;
                end
            end
        end

        function delete(c)
            h = findobj('Tag', c.name);
            if ~isempty(h)
                delete( get(h, 'Parent') );
            end
        end

        function display(c)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(c))
            if loose
                disp(' ');
            end
        end

        function s = char(c, s)
            s = '';
            if ~isempty(c.s)
                s = strvcat(s, sprintf('  pixel size:     (%.4g, %.4g)', c.su, c.sv));
            end
            if ~isempty(c.pp)
                s = strvcat(s, sprintf('  principal pt:   (%.4g, %.4g)', c.u0, c.v0));
            end
            if ~isempty(c.npix)
                s = strvcat(s, sprintf('  number pixels:  %d x %d', c.nu, c.nv));
            end
            if ~isempty(c.noise)
                s = strvcat(s, sprintf('  noise: %.4g,%.4g pix', c.noise));
            end
            s = strvcat(s, sprintf('  Tcam:'));
            s = strvcat(s, [repmat('      ', 4,1) num2str(c.Tcam)]);
        end

        function v = get.u0(c)
            v = c.pp(1);
        end

        function v = get.v0(c)
            v = c.pp(2);
        end

        function v = get.su(c)
            v = c.s(1);
        end

        function v = get.sv(c)
            v = c.s(2);
        end

        function v = get.nu(c)
            v = c.npix(1);
        end

        function v = get.nv(c)
            v = c.npix(2);
        end

        function rpy(c, roll, pitch, yaw)
            if nargin == 2,
                pitch = roll(2);
                yaw = roll(3);
                roll = roll(1);
            end
            c.Tcam = r2t( rotz(roll) * roty(pitch) * rotx(yaw) );
        end

        function c = set.Tcam(c, Tc)
            if ~ishomog(Tc)
                error('camera pose must be a homogeneous transform');
            end
            c.Tcam = Tc;
        end

        function c = set.s(c, sxy)
            if isempty(sxy)
                c.s = sxy;
            elseif length(sxy) == 1,
                c.s = [sxy sxy];
            elseif length(sxy) == 2,
                c.s = sxy(:)';
            else
                error('need 1 or 2 scale elements');
            end
        end

        function c = set.pp(c, pp)
            if isempty(pp)
                c.pp = [];
            elseif length(pp) == 1,
                c.pp = [pp pp];
            elseif length(pp) == 2,
                c.pp = pp(:)';
            else
                error('need 1 or 2 pp elements');
            end
        end

         function c = set.npix(c, npix)
             if ~isempty(npix)
                 if length(npix) == 1,
                     c.npix = [npix npix];
                 elseif length(npix) == 2,
                     c.npix = npix(:)';
                 else
                     error('need 1 or 2 npix elements');
                 end
                 c.limits = [0 c.npix(1) 0 c.npix(2)];
             end
         end

        function hold(c, flag)
            if nargin < 2
                flag = true;
            end
            h = findobj('Tag', c.name);
            if ~isempty(h),
                if flag
                    set(h, 'NextPlot', 'add');
                else
                    set(h, 'NextPlot', 'replacechildren');
                end
            end
        end

        function clf(c, flag)
            h = findobj('Tag', c.name);
            if ~isempty(h),
                children = get(h, 'Children');
                for child=children
                    delete(child)
                end
                c.h_plot = [];
            end
        end

        function h = create(c, name)
            if (nargin == 2) && isstr(name),
                c.name = name;  % allow camera to be renamed
            end

            if (nargin == 2) && ishandle(name),
                % draw camera in an existing axes
                h = name;
            else
                % we need an axis to draw in
                h = findobj('Tag', c.name);
                if isempty(h)
                    disp('no camera axis found');
                    if findobj(gcf, 'Tag', 'camera')
                        % this figure is already a camera
                        disp('this fig is a camera, make a new one');
                    end
                    h = axes
                    disp('make axes');
                    axis square
                    set(gcf, 'MenuBar', 'none');
                    set(gcf, 'Tag', 'camera');
                    set(gca, 'Color', [0.9 0.9 0]);
                else
                    disp('found existing axis')
                end
            end
            % create an axis for camera view
            set(h, 'XLim', c.limits(1:2), 'YLim', c.limits(3:4), ...
                'DataAspectRatio', [1 1 1], ...
                'Xgrid', 'on', 'Ygrid', 'on', ...
                'Ydir' , 'reverse', ...
                'DefaultLineLineStyle', 'none', ...
                'DefaultLineColor', 'black', ...
                'DefaultLineMarker', 'o', ...
                'DefaultLineMarkerEdgeColor', 'black', ...
                'DefaultLineMarkerFaceColor', 'black', ...
                'NextPlot', 'replacechildren', ...
                'Tag', c.name ...
                );
            if ~isempty(c.npix)
                xlabel('u (pixels)');
                ylabel('v (pixels)');
            else
                xlabel('x (m)');
                ylabel('y (m)');
            end
            title(h, c.name);
            figure( get(h, 'Parent') );   % raise the camera view

            c.handle = h;       % keep this around
        end

        %   uv = GCAMERA(H, POINTS, Tcam, Tobj)
        function v =  plot(c, points, varargin)
            %% animate points

            Tobj = eye(4,4);

            if nargin > 2 && (ishomog(varargin{1}) || isempty(varargin{1}))
                Tobj  = varargin{1};
                varargin = varargin(2:end);
            end

            % look for an axis that displays this camera
            h = findobj('Tag', c.name);

            if isempty(h)
                disp('creating new figure for camera')
                h = c.create
            end

            axes(h);        % make them the current axes:w

            nr = numrows(points);
            if (nr == 3) || (nr == 4),
                % TODO: why nr==4?  for homog points?

                % draw points
                uv = c.project(points, Tobj);
                varargin{:}
                if isempty(c.h_plot) || ~ishandle(c.h_plot)
                    % create a line
                    c.h_plot = line('xdata', uv(1,:), 'ydata', uv(2,:), varargin{:});
                else
                    set(c.h_plot, 'xdata', uv(1,:), 'ydata', uv(2,:), varargin{:});
                end
                if nargout > 0,
                    v = uv;
                end
            elseif nr == 6,
                % draw line segments
                nsteps = 21;

                c.clf();

                hold on

                for i=1:numcols(points)
                    P0 = points(1:3,i);
                    P1 = points(4:6,i);
                    if c.perspective
                        % straight world lines are straight on the image plane
                        uv = c.project([P0 P1], Tobj);
                    else
                        % straight world lines are not straight, plot them piecewise
                        P = [];
                        for j=1:nsteps
                            s = (j-1)/(nsteps-1);   % distance along line
                            P = [P (1-s)*P0 + s*P1];
                            uv = c.project(P, Tobj);
                        end
                    end
                    plot(uv(1,:)', uv(2,:)');
                end

                hold off
            else
                error('Points matrix should be 3 or 6 rows');
            end
        end

    end % methods
end % class
