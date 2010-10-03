%CentralCamera  Central perspective camera class
%
%   C = camera         default camera, 1024x1024, f=8mm, 10um pixels, camera at 
%                             origin, optical axis is z-axis, u||x, v||y).
%   C = camera(f, s, pp, npix, name)
%   C = camera(0)           f=sx=sy=1, u0=v0=0: normalized coordinates
%
%   This camera model assumes central projection, that is, the focal point
%   is at z=0 and the image plane is at z=f.  The image is not inverted.
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
%              Z-axis is into the page.
%
% Object properties (read/write)
%
%   C.f           intrinsic: focal length 
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
%   C.plot_epiline(F, p)
%
%   C.invH(H)     return solutions for camera motion and plane normal
%   C.invE(E)     return solutions for pose from essential matrix 4x4x4
%
%   C.rpy(r,p,y)   set camera rpy angles
%   C.rpy(rpy)
%
%   uv = C.project(P)     return image coordinates for world points  P
%   uv = C.project(P, T)  return image coordinates for world points P 
%                          transformed by T prior to projection
%
% P is a list of 3D world points and the corresponding image plane points are 
% returned in uv.  Each point is represented by a column in P and uv.
%
% If P has 3 columns it is treated as a number of 3D points in  world 
% coordinates, one point per row.
%
% If POINTS has 6 columns, each row is treated as the start and end 3D 
% coordinate for a line segment, in world coordinates.  
%
% The optional arguments, T, represents a transformation that can be applied
% to the object data, P, prior to 'imaging'.  The camera pose, C.Tcam, is also 
% taken into account.
%
%   uv = C.plot(P)    display image coordinates for world points P
%   uv = C.plot(P, T) isplay image coordinates for world points P transformed by T
%
% Points are displayed as a round marker.  Lines are displayed as line segments.
% Optionally returns image plane coordinates uv.
%
%   C.show
%   C.show(name)
%
% Create a graphical camera with name, and pixel dimensions given by C.npix.  
% Automatically called on first call to plot().

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
classdef CentralCamera < Camera

    properties
        f       % focal length
        k       % radial distortion vector
        p       % tangential distortion parameters
        distortion  % camera distortion [k1 k2 k3 p1 p2]
    end

    properties (SetAccess = private)
    end

    properties (GetAccess = private, SetAccess = private)

    end

    properties (GetAccess = private)
    end

    properties (Dependent = true, SetAccess = private)
    end

    methods

        %
        %   Return a camera intrinsic parameter structure:
        %       focal length 8mm
        %       pixel size 10um square
        %       image size 1024 x 1024
        %       principal point (512, 512)
        function c = CentralCamera(varargin)
            % invoke the superclass constructor
            c = c@Camera(varargin{:});
            c.type = 'central-perspective';
            c.perspective = true;

            if nargin == 0,
                c.name = 'canonic';
                % default values
                c.f = 1;
                c.distortion = [];
            elseif nargin == 1 && isa(varargin{1}, 'CentralCamera')
                % copy constructor
                old = varargin{1};
                for p=properties(c)'
                    % copy each property across, exceptions occur
                    % for those with protected SetAccess
                    p = p{1};
                    try
                        c = setfield(c, p, getfield(old, p));
                    end
                end
            end
            if isempty(c.pp) && ~isempty(c.npix)
                c.pp = c.npix/2;
            elseif isempty(c.pp)
                c.pp =[0 0];
            end
        end

        function n = paramSet(c, args)
            n = 0;
            switch lower(args{1})
            case 'focal'
                c.f = args{2}; n = 1;
            case 'distortion'
                v = args{2}; n = 1;
                if length(v) ~= 5
                    error('distortion vector is [k1 k2 k3 p1 p2]');
                end
                c.distortion = v;
            case 'distortion-bouget'
                v = args{2}; n = 1;
                if length(v) ~= 5
                    error('distortion vector is [k1 k2 p1 p2 k3]');
                end
                c.distortion = [v(1) v(2) v(5) v(3) v(4)];;
            case 'default'
                c.f = 8e-3;     % f
                c.rho = [10e-6, 10e-6];      % square pixels 10um side
                c.npix = [1024, 1024];  % 1Mpix image plane
                c.pp = [512, 512];      % principal point in the middle
                c.limits = [0 1024 0 1024];
            otherwise
                error('VisionToolbox:CentralCamera:UnknownOption', 'Unknown option %s', args{1});
            end
        end


        function s = char(c)

            s = sprintf('name: %s [%s]', c.name, c.type);
            s = strvcat(s, sprintf(    '  focal length:   %-11.4g', c.f));
            if ~isempty(c.distortion)
                s = strvcat(s, sprintf('  distortion:     k=(%.4g, %.4g, %.4g), p=(%.4g, %.4g)', c.distortion));
            end
            s = strvcat(s, char@Camera(c) );
        end

        % intrinsic parameter matrix
        function v = K(c)
            v = [   c.f/c.rho(1)   0           c.pp(1) 
                    0          c.f/c.rho(2)    c.pp(2)
                    0          0           1%/c.f
                ] ;
        end

        % camera calibration or projection matrix
        function v = C(c, Tcam)
            if nargin == 1,
                Tcam = c.T;
            end

            if isempty(c.rho)
                rho = [1 1];
            else
                rho = c.rho;
            end

            v = [   c.f/rho(1)     0           c.pp(1)   0
                    0            c.f/rho(2)    c.pp(2)   0
                    0            0           1         0
                ] * inv(Tcam);
        end

        function HH = H(c, T, n, d)
            
            if (d < 0) || (n(3) < 0)
                error('plane distance must be > 0 and normal away from camera');
            end
            
            % T is the transform from view 1 to view 2
            % (R,t) is the inverse
            T = inv(T);
            
            R = t2r( T );
            t = transl( T );

            HH = R + 1.0/d*t*n(:)';

            % now apply the camera intrinsics
            K = c.K
            HH = K * HH * inv(K);
            HH = HH / HH(3,3);     % normalize it
        end
        
        function s = invH(c, H, varargin)
            if nargout == 0
                invhomog(H, 'K', c.K, varargin{:});
            else
                s = invhomog(H, 'K', c.K, varargin{:});
            end
        end
        
        function fmatrix = F(c, X)
            % cam.F(X)
            % cam.F(cam2)   with 
            
            % REF: An Invitation to 3D geometry, p.177
            
            % T is the pose for view 1 
            % c.T is the pose for view 2

            if ishomog(X)
                E = c.E(X);
                K = c.K();
                fmatrix = inv(K)' * E * inv(K);
            elseif  isa(X, 'Camera')
                % use relative pose and camera parameters of 
                E = c.E(X);
                K1 = c.K;
                K2 = X.K();
                fmatrix = inv(K2)' * E * inv(K1);
            end
        end
        
        % E = cam1.E(F)     convert F matrix to E using camera intrinsics
        % E = cam1.E(T12)   compute E for second view displaced by T12 from first
        % E = cam1.E(cam2)  compute E for second view given by cam2 and first view given
        %                    by cam1
        function ematrix = E(c, X)

            % essential matrix from pose.  Assume the first view is associated
            % with the passed argument, either a hom.trans or a camera.
            % The second view is Tcam of this object.
            if ismatrix(X) && all(size(X) == [3 3]),
                % essential matrix from F matrix
                F = X;

                K = c.K();
                ematrix = K'*F*K;
                return;
            elseif isa(X, 'Camera')
                T21 = inv(X.T) * c.T;
            elseif ishomog(X)
                T21 = inv(X);
            else
                error('unknown argument type');
            end

            % T = (R,t) is the transform from transform from 2 --> 1
            %
            % as per Hartley & Zisserman p.244
            %   P' = K' [R t] where [R t] is inverse camera pose, PIC book (8.5)
            %
            % as per Ma etal. p.100
            %   X2 = RX1 + t, so [R t] is the transform from C2 to C1

            [R,t] = t2rt(T21);
            
            % REF: An Invitation to 3D geometry, p.177
            %   E = Sk(t) R

            ematrix = skew(t) * R;
        end
        
        function s = invE(c, E, P)
            % REF: Hartley & Zisserman, Chap 9, p. 259

            % we return T from view 1 to view 2
            
            [U,S,V] = svd(E);
            % singular values are (sigma, sigma, 0)
            
            if 0
                % H&Z solution
                W = [0 -1 0; 1 0 0; 0 0 1];   % rotz(pi/2)

                t = U(:,3);
                R1 = U*W*V';
                if det(R1) < 0,
                    disp('flip');
                    V = -V;
                    R1 = U*W*V';
                    det(R1)
                end
                R2 = U*W'*V';

                % we need to invert the solutions since our definition of pose is
                % from initial camera to the final camera
                s(:,:,1) = inv([R1 t; 0 0 0 1]);
                s(:,:,2) = inv([R1 -t; 0 0 0 1]);
                s(:,:,3) = inv([R2 t; 0 0 0 1]);
                s(:,:,4) = inv([R2 -t; 0 0 0 1]);
            else
                % Ma etal solution, p116, p120-122
                % Fig 5.2 (p113), is wrong, (R,t) is from camera 2 to 1
                if det(V) < 0
                    V = -V;
                    S = -S;
                end
                if det(U) < 0
                    U = -U;
                    S = -S;
                end
                R1 = U*rotz(pi/2)'*V';
                R2 = U*rotz(-pi/2)'*V';
                t1 = vex(U*rotz(pi/2)*S*U');
                t2 = vex(U*rotz(-pi/2)*S*U');
                % invert (R,t) so its from camera 1 to 2
                s(:,:,1) = inv( [R1 t1; 0 0 0 1] );
                s(:,:,2) = inv( [R2 t2; 0 0 0 1] );
            end
            
            if nargin > 2
                for i=1:size(s,3)
                    if ~any(isnan(c.project(P, 'Tcam', s(:,:,i))))
                        s = s(:,:,i);
                        fprintf('solution %d is good\n', i);
                        return;
                    end
                end
                warning('no solution has given point in front of camera');
            end
        end
        
        % plot a line specified in theta-rho format
        function plot_line_tr(cam, lines, varargin)

            x = get(cam.h_image, 'XLim');
            y = get(cam.h_image, 'YLim');

            % plot it
            for i=1:numcols(lines)
                theta = lines(1,i);
                rho = lines(2,i);
                %fprintf('theta = %f, d = %f\n', line.theta, line.rho);
                if abs(cos(theta)) > 0.5,
                    % horizontalish lines
                    plot(x, -x*tan(theta) + rho/cos(theta), varargin{:}, 'Parent', cam.h_image);
                else
                    % verticalish lines
                    plot( -y/tan(theta) + rho/sin(theta), y, varargin{:}, 'Parent', cam.h_image);
                end
            end
        end

        function handles = plot_epiline(c, F, p, varargin)

            % for all input points
            l = F * e2h(p);

            c.line(l, varargin{:});
        end

        % return field-of-view angle for x and y direction (rad)
        function th = fov(c)
            th = 2*atan(c.npix/2.*c.rho / c.f);
        end


        % do the camera perspective transform
        %   P is 3xN matrix of points to plot
        function uv = project(c, P, varargin)

            opt.Tobj = [];
            opt.Tcam = [];

            [opt,arglist] = tb_optparse(opt, varargin);

            np = numcols(P);
                
            if isempty(opt.Tcam)
                opt.Tcam = c.T;
            end

            if ndims(opt.Tobj) == 3 && ndims(opt.Tcam) == 3
                error('cannot animate object and camera simultaneously');
            end

            if ndims(opt.Tobj) == 3
                % animate object motion, static camera

                % get camera matrix for this camera pose
                C = c.C(opt.Tcam);

                % make the world points homogeneous
                if numrows(P) == 3
                    P = e2h(P);
                end

                for frame=1:size(opt.Tobj,3)

                    % transform all the points to camera frame
                    X = C * opt.Tobj(:,:,frame) * P;     % project them

                    X(3,X(3,:)<0) = NaN;    % points behind the camera are set to NaN
                    X = h2e(X);            % convert to Euclidean coordinates

                    if c.noise
                        % add Gaussian noise with specified standard deviation
                        X = X + diag(c.noise) * randn(size(X)); 
                    end
                    uv(:,:,frame) = X;
                end
            else
                % animate camera, static object

                % transform the object
                if ~isempty(opt.Tobj)
                    P = transformp(Tobj, P);
                end

                % make the world points homogeneous
                if numrows(P) == 3
                    P = e2h(P);
                end

                for frame=1:size(opt.Tcam,3)
                    C = c.C(opt.Tcam(:,:,frame));

                    % transform all the points to camera frame
                    X = C * P;              % project them
                    X(3,X(3,:)<0) = NaN;    % points behind the camera are set to NaN
                    X = h2e(X);            % convert to Euclidean coordinates

                    if c.noise
                        % add Gaussian noise with specified standard deviation
                        X = X + diag(c.noise) * randn(size(X)); 
                    end
                    uv(:,:,frame) = X;
                end
            end
        end

        function r = ray(cam, p)
            % from HZ p 162
            C = cam.C();
            Mi = inv(C(1:3,1:3));
            p4 = C(:,4);
            for i=1:numcols(p)
                r(i) = Ray3D(-Mi*p4, Mi*e2h(p(:,i)));
            end
        end

        function hg = drawCamera(cam, s, varargin)

            hold on
            if nargin == 0
                s = 1;
            end

            s = s/3;

            opt.color = 'b';
            opt.mode = {'solid', 'mesh'};
            opt.label = false;
            opt = tb_optparse(opt, varargin);

            % create a new transform group
            hg = hgtransform;

            % the box is centred at the origin and its centerline parallel to the
            % z-axis.  Its z-extent is -bh/2 to bh/2.
            bw = 0.5;       % half width of the box
            bh = 1.2;       % height of the box
            cr = 0.4;       % cylinder radius
            ch = 0.8;       % cylinder height
            cn = 16;        % number of facets of cylinder
            a = 3;          % length of axis line segments

            opt.scale = s;
            opt.parent = hg;

            % draw the box part of the camera
            r = bw*[1; 1];
            x = r * [1 1 -1 -1 1];
            y = r * [1 -1 -1 1 1];
            z = [-bh; bh]/2 * ones(1,5);
            draw(x,y,z, opt);

            % draw top and bottom of box
            x = bw * [-1 1; -1 1];
            y = bw * [1 1; -1 -1];
            z = [1 1; 1 1];

            draw(x,y,-bh/2*z, opt);
            draw(x,y,bh/2*z, opt);


            % draw the lens
            [x,y,z] = cylinder(cr, cn);
            z = ch*z+bh/2;
            h = draw(x,y,z, opt);
            set(h, 'BackFaceLighting', 'unlit');

            % draw the x-, y- and z-axes
            h = plot3([0,a*s], [0,0], [0,0], 'k')
            set(h, 'Parent', hg);
            h = plot3([0,0], [0,a*s], [0,0], 'k')
            set(h, 'Parent', hg);
            h = plot3([0,0], [0,0], [0,a*s], 'k')
            set(h, 'Parent', hg);

            if opt.label
                h = text( a*s,0,0, cam.name);
                set(h, 'Parent', hg);
            end
            hold off


            function h = draw(x, y, z, opt)

                s = opt.scale;
                switch opt.mode
                case 'solid'
                    h = surf(x*s,y*s,z*s, 'FaceColor', opt.color);
                case 'surfl'
                    h = surfl(x*s,y*s,z*s, 'FaceColor', opt.color);
                case 'mesh'
                    h = mesh(x*s,y*s,z*s, 'EdgeColor', opt.color);
                end

                set(h, 'Parent', opt.parent);
            end
        end
    end % methods
end % class
