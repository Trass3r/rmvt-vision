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
%   C.epiline(F, p)
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

            % default values
            c.type = 'central-perspective';
            c.f = 1;
            c.distortion = [];

            if nargin == 0,
                c.name = 'canonic';
            else
                c.name = 'noname';

                count = 1;
                while count <= length(varargin)
                    switch lower(varargin{count})
                    case 'focal'
                        c.f = varargin{count+1}; count = count+1;
                    case 'distortion'
                        v = varargin{count+1}; count = count+1;
                        if length(v) ~= 5
                            error('distortion vector is [k1 k2 k3 p1 p2]');
                        end
                        c.distortion = v;
                    case 'default'
                        c.f = 8e-3;     % f
                        c.s = [10e-6, 10e-6];      % square pixels 10um side
                        c.npix = [1024, 1024];  % 1Mpix image plane
                        c.pp = [512, 512];      % principal point in the middle
                        c.limits = [0 1024 0 1024];
                        c.name = 'default';
                    otherwise
                        error( sprintf('unknown option <%s>', varargin{count}));
                    end
                    count = count + 1;
                end
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
            v = [   c.f/c.s(1)   0           c.pp(1) 
                    0            c.f/c.s(2)  c.pp(2)
                    0            0           1
                ] ;
        end

        % camera calibration or projection matrix
        function v = C(c, Tcam)
            if nargin == 1,
                Tcam = c.Tcam;
            end

            if isempty(c.s)
                s = [1 1];
            else
                s = c.s;
            end

            v = [   c.f/s(1)     0           c.pp(1)   0
                    0            c.f/s(2)    c.pp(2)   0
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
        
        function s = invH(c, H)
            if nargout == 0
                invhomog(H, c.K);
            else
                s = invhomog(H, c.K);
            end
        end
        
        function FF = F(c, T)
            
            % REF: An Invitation to 3D geometry, p.177
            
            % T is the transform from view 1 to view 2
            % (R,t) is the inverse
            if nargin == 1,
                T = c.Tcam;
            end
            T = inv(T);
            
            R = t2r( T );
            t = transl( T );

            F = skew(t) * R;

            % now apply the camera intrinsics
            K = c.K;
            FF = inv(K)' * F * inv(K);
            FF = FF / FF(3,3);     % normalize it
        end
        
        function EE = E(c, T)
            
            if ishomog(T),
                % essential matrix from pose
                % REF: An Invitation to 3D geometry, p.177

                % T is the transform from view 1 to view 2
                % (R,t) is the inverse
                T = inv(T);

                R = t2r( T );
                t = transl( T );

                EE = skew(t) * R;
                EE = EE / EE(3,3);  % normalize it
            elseif all(size(T) == [3 3]),
                % essential matrix from F matrix
                K = c.K;
                EE = K'*T*K;
            end
        end
        
        function s = invE(c, E)
            % REF: Hartley & Zisserman, Chap 9
            
            W = [0 -1 0; 1 0 0; 0 0 1];
            [U,S,V] = svd(E);
            
            t = U(:,3);
            R1 = U*W*V';
            if det(R1) < 0,
                V = -V;
                R1 = U*W*V';
            end
            R2 = U*W'*V';
            
            s(:,:,1) = inv( [R1 t; 0 0 0 1] );
            s(:,:,2) = inv( [R1 -t; 0 0 0 1] );
            s(:,:,3) = inv( [R2 t; 0 0 0 1] );
            s(:,:,4) = inv( [R2 -t; 0 0 0 1] );
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

        function handles = epiline(c, F, p, ls)

            % get plot limits from current graph
            xlim = get(gca, 'XLim');
            xmin = xlim(1);
            xmax = xlim(2);

            if nargin < 4,
                ls = 'r';
            end
            h = [];
            % for all input points
            l = F * e2h(p);
            for i=1:numcols(p),
                y = (-l(3,i) - l(1,i)*xlim) / l(2,i);
                hold on
                hh = plot(xlim, y, ls);
                h = [h; hh];
                hold off
            end

            if nargout > 0,
                handles = h;
            end
        end

        % return field-of-view angle for x and y direction (rad)
        function th = fov(c)
            th = 2*atan(c.npix/2.*c.s / c.f);
        end

        % do the camera perspective transform
        %   P is 3xN matrix of points to plot
        %   P is 4x4 transform whose transl component is plotted
        function uv = project(c, P, Tcam)

            np = numrows(P);
                
            if nargin < 3,
                C = c.C;
            else
                C = c.C(Tcam);
            end
            
            if numrows(P) == 4,
                P = transl(P);
            end

            % transform all the points to camera frame
            X = C * e2h(P);         % project them
            X(3,X(3,:)<0) = NaN;    % points behind the camera are set to NaN
            uv = h2e(X);            % convert to Euclidean coordinates

            if c.noise
                % add Gaussian noise with specified standard deviation
                uv = uv + diag(c.noise) * randn(size(uv)); 
            end
        end
    end % methods
end % class
