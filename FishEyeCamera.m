%FishEyeCamera  Fish eye camera class
%
%   C = camera    default camera, 1024x1024, f=8mm, 10um pixels, camera at 
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
%
% SEE ALSO: Camera

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
classdef FishEyeCamera < Camera

    properties
        k       % radial distortion vector
        model   % projection model
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
        function c = FishEyeCamera(varargin)


            % invoke the superclass constructor
            c = c@Camera(varargin{:});
            c.type = 'FishEye';

            if nargin == 0,
                % default values
                c.type = 'fisheye';
                c.k = 1;
                c.model = 'equiangular';
                c.name = 'fisheye-default';

            else
                if isempty(c.k)
                    % compute k if not specified, so that hemisphere fits into
                    % image plane
                    r = min([(c.npix-c.pp).*c.rho, c.pp.*c.rho]);
                    switch c.model
                    case 'equiangular'
                        c.k = r / (pi/2);
                    case 'sine'
                        c.k = r;
                    case 'equisolid'
                        c.k = r / sin(pi/4);
                    case 'stereographic'
                        c.k = r / tan(pi/4);
                        r = c.k * tan(theta/2);
                    otherwise
                        error('unknown fisheye projection model');
                    end
                end
            end
        end

        function n = paramSet(c, args)
            switch lower(args{1})
            case 'k'
                c.k = args{2}; n = 1;
            case 'projection'
                c.model = args{2}; n = 1;
            case 'default'
                c.rho = [10e-6, 10e-6];      % square pixels 10um side
                c.npix = [1024, 1024];  % 1Mpix image plane
                c.pp = [512, 512];      % principal point in the middle
                c.limits = [0 1024 0 1024];
                c.name = 'default';
                r = min([(c.npix-c.pp).*c.rho, c.pp.*c.rho]);
                c.k = 2*r/pi;
                n = 0;
            otherwise
                error( sprintf('unknown option <%s>', args{count}));
            end
        end

        function s = char(c)

            s = sprintf('name: %s [%s]', c.name, c.type);
            s = strvcat(s, sprintf(    '  model:          %s', c.model));
            s = strvcat(s, sprintf(    '  k:              %-11.4g', c.k));
            s = strvcat(s, char@Camera(c) );
        end

        % return field-of-view angle for x and y direction (rad)
        function th = fov(c)
            th = 2*atan(c.npix/2.*c.s / c.f);
        end

        % do the fisheye projection
        function uv = project(c, P, varargin)

            np = numcols(P);
                
            opt.Tobj = [];
            opt.Tcam = [];

            [opt,arglist] = tb_optparse(opt, varargin);
            
            if isempty(opt.Tcam)
                opt.Tcam = c.T;
            end
            if isempty(opt.Tobj)
                opt.Tobj = eye(4,4);
            end
            
            % transform all the points to camera frame
            X = homtrans(inv(opt.Tcam) * opt.Tobj, P);         % project them

            R = colnorm(X(1:3,:));
            phi = atan2( X(2,:), X(1,:) );
            theta = acos( X(3,:) ./ R );

            switch c.model
            case 'equiangular'
                r = c.k * theta;
            case 'sine'
                r = c.k * sin(theta);
            case 'equisolid'
                r = c.k * sin(theta/2);
            case 'stereographic'
                r = c.k * tan(theta/2);
            otherwise
                error('unknown fisheye projection model');
            end

            x = r .* cos(phi);
            y = r .* sin(phi);

            uv = [x/c.rho(1)+c.pp(1); y/c.rho(2)+c.pp(2)];

            if c.noise
                % add Gaussian noise with specified standard deviation
                uv = uv + diag(c.noise) * randn(size(uv)); 
            end
        end
    end % methods
end % class
