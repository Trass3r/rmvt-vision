%SHOWCAMERA Display a camera icon in 3D
%
%   h = showcamera(T)
%
%  Create a new camera at pose T, and return the graphics handle.
%
%   showcamera(h, T)
%
%  Change the pose of the camera with handle h, to T.
%
% The camera is depicted as a pyramid with the apex as the camera
% origin and the base plane normal to the optical axis.
% The sides are colored red, green, blue corresponding to the X, Y, Z axes
% respectively.


function h = showcamera(varargin)


    if (nargin == 2) && isscalar(varargin{1}) && ishandle(varargin{1}),
        %% update the camera pose
        h = varargin{1};
        T = varargin{2};

        ud = get(h, 'UserData');
        vertices = transformp(ud.vertices, T);

        set(h, 'Vertices', vertices);        
    else
        %% initialize the camera view
        if nargin == 1,
            % get the overall scale factor from the existing graph
            sz = [get(gca, 'Xlim'); get(gca, 'Ylim'); get(gca, 'Zlim')];
            sz = max(sz(:,2)-sz(:,1));
            sz = sz / 20;
        else
            % else take it from the second argument
            sz = varargin{2};
        end
        
        % define pyramid dimensions from the size parameter
        w = sz;
        l = sz*2;
        
        % define the vertices of the camera
        vertices = [
             0    0    0
             w/2  w/2  l
            -w/2  w/2  l
            -w/2 -w/2  l
             w/2 -w/2  l
            ];
 
        ud.vertices = vertices;
        T = varargin{1};

        % create the camera 
        vertices = transformp(vertices, T);

        % the first index for each face controls the face color
        faces = [
            1 2 5 NaN
            2 1 3 NaN
            3 4 1 NaN
            4 1 5 NaN
            5 2 3 4
            %2 3 4 5
            ];

        colors = [
            1 0 0       % R
            0 1 0       % G
            1 0 0       % R
            0 1 0       % G
            0 0 1       % B
            ];

        h = patch('Vertices', vertices, ...
            'Faces', faces, ...
            'FaceVertexCData', colors, ...
            'FaceColor','flat', ...
            'UserData', ud);

        set(h, 'FaceAlpha', 0.5);
    end
