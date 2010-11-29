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
%   C.pp          principal point (u0, v0)
% 
% Object methods
%
%   C.fov         return camera half field-of-view angles (2x1 rads)
%   C.K           return camera intrinsic matrix (3x3)
%   C.C           return camera project matrix for camera pose (3x4)
%   C.C(Tcam)     return camera intrinsic matrix for specified camera pose (3x4)
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
%   uv = C.project(P, Tp)    return image coordinates for world points P transformed by Tp
%
% GRAPHICS:
%   C.clf
%   C.hold             turn hold on
%   C.hold(e)          turn hold on or off
%
%  Image plane primitives
%
%   C.point(Ph, opt)    plot points given in homogeneous form
%   C.line(Ph, opt)    plot lines given in homogeneous form
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
%
%   Return handle to the axes for this camera's graphical display, if it doesn't exist then create it.

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
        rho     % pixel dimensions 1x2
        pp      % principal point 1x2
        npix    % number of pixel 1x2
        T       % camera pose
        noise   % pixel noise 1x2
        image
    end

    properties (SetAccess = protected)
        handle
        limits
        perspective
        h_image % handle for image plane
        h_visualize % handle for camera 3D view
        h_camera3D    % handle for camera animation transform
        P           % world points, last plotted
        holdon
    end

    properties (GetAccess = protected, SetAccess = protected)

    end

    properties (GetAccess = private)
    end

    properties (Dependent = true, SetAccess = protected)
        u0
        v0
        nu
        nv
    end
    
    methods (Abstract)
        p = project(c, T1, T2);
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
            c.T = eye(4,4);
            c.rho = [1 1];
            c.pp = [];
            c.limits = [-1 1 -1 1];
            c.npix = [];
            c.noise = [];
            c.name = 'unnamed';
            c.perspective = false;
            c.h_image = [];
            c.h_camera3D = [];
            c.h_visualize = [];
            c.holdon = false;
            c.image = [];
            sensor = [];

            if nargin == 0,
                c.name = 'canonic';
                c.pp = [0 0];
            elseif nargin == 1 && isa(varargin{1}, 'Camera')
                return;
            else
                c.name = 'noname';

                count = 1;
                args = varargin;
                while count <= length(args)
                    switch lower(args{count})
                    case 'name'
                        c.name = args{count+1}; count = count+1;
                    case 'image'
                        c.image = args{count+1}; count = count+1;
                        c.npix = [size(c.image,2) size(c.image,1)];
                    case 'resolution'
                        v = args{count+1}; count = count+1;
                        if length(v) == 1
                            v = [v v];
                        end
                        c.npix = v;
                    case {'principal', 'centre'}
                        c.pp = args{count+1}; count = count+1;
                    case 'sensor'
                            sensor = args{count+1}; count = count+1;
                    case 'pixel'
                        s = args{count+1}; count = count+1;
                        c.rho = s;
                    case 'noise'
                        v = args{count+1}; count = count+1;
                        if length(v) == 1
                            v = [v v];
                        end
                        c.noise = v;
                    case 'pose'
                        c.T = args{count+1}; count = count+1;
                    otherwise
                        % if the parameter is not known by the base class, call
                        % the parameter handler in the derived class.
                        % it returns the number of additonal parameters consumed.
                        n = c.paramSet(args(count:end));
                        count = count + n;
                    end
                    count = count + 1;
                end
            end
            if ~isempty(sensor)
                c.rho = sensor ./ c.npix;
            end
            if length(c.rho) == 1
                c.rho = ones(1,2) * c.rho;
            end
            if isempty(c.pp)
                fprintf('principal point not specified, setting it to centre of image plane\n');
                c.pp = c.npix / 2;
            end
            c.pp
        end

        function delete(c)
            disp('delete camera object');
            if ~isempty(c.h_image)
                delete(get(c.h_image, 'Parent'));
            end
            if ~isempty(c.h_visualize)
                delete(get(c.h_visualize, 'Parent'));
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
            if ~isempty(c.rho)
                s = strvcat(s, sprintf('  pixel size:     (%.4g, %.4g)', c.rho(1), c.rho(2)));
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
            s = strvcat(s, sprintf('  T:'));
            s = strvcat(s, [repmat('      ', 4,1) num2str(c.T)]);
        end

        function v = get.u0(c)
            v = c.pp(1);
        end

        function v = get.v0(c)
            v = c.pp(2);
        end

        function v = get.rho(c)
            v = c.rho;
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
            c.T = r2t( rotz(roll) * roty(pitch) * rotx(yaw) );
        end

        function c = set.T(c, Tc)
            if isempty(Tc)
                c.T = eye(4,4);       
            elseif ~ishomog(Tc)
                error('camera pose must be a homogeneous transform');
            else
                c.T = Tc;
            end
            if ~isempty(c.h_camera3D) && ishandle(c.h_camera3D)
                set(c.h_camera3D, 'Matrix', c.T);
            end
        end

        function c = centre(c)
            c = transl(c.T);
        end

        function c = set.rho(c, sxy)
            if isempty(sxy)
                c.rho = sxy;
            elseif length(sxy) == 1,
                c.rho = [sxy sxy];
            elseif length(sxy) == 2,
                c.rho = sxy(:)';
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
            c.holdon = flag;
            if flag
                set(c.h_image, 'NextPlot', 'add');
            else
                set(c.h_image, 'NextPlot', 'replacechildren');
            end
        end

        function v = ishold(c)
            v = c.holdon;
        end

        function clf(c, flag)
            h = c.h_image;
            if ~isempty(h) && ishandle(h)
                children = get(h, 'Children');
                for child=children
                    delete(child)
                end
            end
        end

        % Return the graphics handle for this camera's image plane
        % and create the graphics if it doesnt exist
        %
        function h = plot_create(c, hin)

            % if this camera is created from an image, then display that image
            if ~isempty(c.image)

                if isempty(c.h_image) || ~ishandle(c.h_image)
                    idisp(c.image, 'nogui');
                    set(gcf, 'name', [class(c) ':' c.name]);
                    set(gcf, 'MenuBar', 'none');
                    hold on
                    h = gca;
                    title(h, c.name);
                    c.h_image = h;
                    set(gcf, 'HandleVisibility', 'off');
                    set(h, 'HandleVisibility', 'off');
                else
                    h = c.h_image;
                end
                h
                return;
            end

            if ishandle(c.h_image)
                h = c.h_image;
                return;
            end

            disp('creating new figure for camera')
            if (nargin == 2) && ishandle(hin),
                % draw camera in an existing axes
                h = hin;
                set(h, 'HandleVisibility', 'off');
            else
                clf
                h = axes
                fig = get(h, 'Parent');
                disp('make axes');
                axis square
                set(fig, 'MenuBar', 'none');
                set(fig, 'Tag', 'camera');
                set(h, 'Color', [1 1 0.8]);
                set(fig, 'HandleVisibility', 'off');
                set(fig, 'name', [class(c) ':' c.name]);
            end
            % create an axis for camera view
            set(h, 'XLim', c.limits(1:2), 'YLim', c.limits(3:4), ...
                'DataAspectRatio', [1 1 1], ...
                'Xgrid', 'on', 'Ygrid', 'on', ...
                'Ydir' , 'reverse', ...
                'NextPlot', 'add', ...
                'Tag', c.name ...
                );
            c.h_image = h;       % keep this around
            c.newplot();
            title(h, c.name);
            figure( fig );   % raise the camera view
            set(h, 'NextPlot', 'replacechildren');
        end
        
        function newplot(c)
            h = c.h_image;
            if ~isempty(c.npix)
                xlabel(h, 'u (pixels)');
                ylabel(h, 'v (pixels)');
            else
                xlabel(h, 'x (m)');
                ylabel(h, 'y (m)');
            end
        end
        

        %   C.plot(P)   plot 3D world points  3xN
        %   C.plot(p)   plot 2D image plane points 2xN
        function v =  plot(c, points, varargin)

            opt.Tobj = [];
            opt.Tcam = [];
            opt.fps = 5;
            opt.sequence = false;
            opt.textcolor = 'k';
            opt.textsize = 12;
            opt.drawnow = false;

            [opt,arglist] = tb_optparse(opt, varargin);

            % get handle for this camera image plane
            h = c.plot_create();

            nr = numrows(points);

            if nr == 3
                % plot 3D world points
                uv = c.project(points, varargin{:});
            else
                uv = points;
            end

            if isempty(arglist)
                % set default style if none given
                %disp('set default plot args');
                arglist = {'Marker', 'o', 'MarkerFaceColor', 'k', 'LineStyle', 'none'};
            end

            for i=1:size(uv,3)
                % for every frame in the animation sequence
                plot(uv(1,:,i), uv(2,:,i), arglist{:}, 'Parent', h);
                if opt.sequence
                    for j=1:size(uv,2)
                        text(uv(1,j,i), uv(2,j,i), sprintf('  %d', j), ...
                            'HorizontalAlignment', 'left', ...
                            'VerticalAlignment', 'middle', ...
                            'FontUnits', 'pixels', ...
                            'FontSize', opt.textsize, ...
                            'Color', opt.textcolor, ...
                            'Parent', h);
                    end
                end

                if size(uv,3) > 1
                    pause(1/opt.fps);
                end
            end

            if opt.drawnow
                drawnow
            end

            if nargout > 0,
                v = uv;
            end
        end % plot

        %   C.mesh(X,Y,Z)   plot 3D world line segments  6xN
        function v =  mesh(c, X, Y, Z, varargin)

            % check that mesh matrices conform
            if ~(all(size(X) == size(Y)) && all(size(X) == size(Z)))
                error('matrices must be the same size');
            end

            % first two optional arguments can be
            %       Tobj
            %       [], Tcam
            %       Tobj, Tcam

            opt.Tobj = [];
            opt.Tcam = [];


            [opt,arglist] = tb_optparse(opt, varargin);
            if isempty(opt.Tcam)
                opt.Tcam = c.T;
            end

            % get handle for this camera image plane
            h = c.plot_create();

            % draw 3D line segments
            nsteps = 21;

            c.clf();
            c.hold(1);

            for i=1:numrows(X)-1
                for j=1:numcols(X)-1
                    P0 = [X(i,j), Y(i,j), Z(i,j)]';
                    P1 = [X(i+1,j), Y(i+1,j), Z(i+1,j)]';
                    P2 = [X(i,j+1), Y(i,j+1), Z(i,j+1)]';

                    if c.perspective
                        % straight world lines are straight on the image plane
                        uv = c.project([P0 P1], 'setopt', opt);
                    else
                        % straight world lines are not straight, plot them piecewise
                        P = [];
                        for j=1:nsteps
                            s = (j-1)/(nsteps-1);   % distance along line
                            P = [P (1-s)*P0 + s*P1];
                        end
                        uv = c.project(P, 'setopt', opt);
                    end
                    plot(uv(1,:)', uv(2,:)', 'Parent', c.h_image);

                    if c.perspective
                        % straight world lines are straight on the image plane
                        uv = c.project([P0 P2], 'setopt', opt);
                    else
                        % straight world lines are not straight, plot them piecewise
                        P = [];
                        for j=1:nsteps
                            s = (j-1)/(nsteps-1);   % distance along line
                            P = [P (1-s)*P0 + s*P2];
                        end
                        uv = c.project(P, 'setopt', opt);
                    end
                    plot(uv(1,:)', uv(2,:)', 'Parent', c.h_image);
                end
            end

            for j=1:numcols(X)-1
                P0 = [X(end,j), Y(end,j), Z(end,j)]';
                P1 = [X(end,j+1), Y(end,j+1), Z(end,j+1)]';

                if c.perspective
                    % straight world lines are straight on the image plane
                    uv = c.project([P0 P1], 'setopt', opt);
                else
                    % straight world lines are not straight, plot them piecewise
                    P = [];
                    for j=1:nsteps
                        s = (j-1)/(nsteps-1);   % distance along line
                        P = [P (1-s)*P0 + s*P1];
                    end
                    uv = c.project(P, 'setopt', opt);
                end
                plot(uv(1,:)', uv(2,:)', 'Parent', c.h_image);
            end
            c.hold(0);

        end % mesh

        % plot multiple points given in homogeneous form
        %  one column per point
        function h =  point(c, p, varargin)

            % get handle for this camera image plane
            h = c.create

            uv = e2h(p);
            h = plot(uv(1,:), uv(2,:), varargin{:});
        end % point

        % plot multiple lines given in homogeneous form
        %  one column per line
        function h =  line(c, lines, varargin)

            % get handle for this camera image plane
            h = c.plot_create
            xlim = get(h, 'XLim');
            ylim = get(h, 'YLim');

            if numel(lines) == 3
                lines = lines(:);
            end

            for l=lines
                if abs(l(1)/l(2)) > 1
                    % steeper than 45deg
                    x = (-l(3) - l(2)*ylim) / l(1);
                    h = plot(x, ylim, varargin{:}, 'Parent', c.h_image);
                else
                    % less than 45deg
                    y = (-l(3) - l(1)*xlim) / l(2);
                    xlim
                    y
                    h = plot(xlim, y, varargin{:}, 'Parent', c.h_image);
                end
            end
        end % line

        function newcam = move(cam, T)
            newcam = CentralCamera(cam);
            newcam.T = newcam.T * T;
        end

        function movedby(c, robot)
            robot.addlistener('Moved', @(src,data)cameramove_callback(src,data,c));

            function cameramove_callback(robot, event, camera)
                camera.T = robot.fkine(robot.q);
            end
        end

        function help(c)
            disp(' C.plot(P)     return image coordinates for world points  P');
            disp(' C.point(P)     return image coordinates for world points  P');
            disp(' C.line(P)     return image coordinates for world points  P');
            disp(' C.clf     return image coordinates for world points  P');
            disp(' C.hold     return image coordinates for world points  P');
            disp(' C.project(P)     return image coordinates for world points  P');
            disp(' C.project(P, Tobj)  return image coordinates for world points P ');
            disp(' C.project(P, To, Tcm)  return image coordinates for world points P ');
            disp(' transformed by T prior to projection');
        end
    end % methods

end % class
