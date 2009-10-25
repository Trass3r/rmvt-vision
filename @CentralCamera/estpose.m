%ESTPOSE Estimate pose from object model and camera view
%
%   T = estpose(camera, xyz, uv)
%
% where camera is a camera object, xyz is an 3xN matrix of
% the world coordinates of N points, and uv is an 2xN matrix
% of the corresponding image plane projections.

function T = estpose(c, XYZ, uv)

    [R, t] = efficient_pnp(XYZ', uv', c.K);

    T = [R t; 0 0 0 1];
