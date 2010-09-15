%ANAGLYPH Convert stereo images to an anaglyph image
%
%   ag = anaglyph(left, right, disp)
%   ag = anaglyph(stereopair, disp)
%
%  The left and right images are given separately or as a 3D image
%  where the last index is 1 for left, and 2 for right.
%
%  The default color encoding is left=red, right=cyan, but can
%  be changed with a trailing option (default is 'rc').
%
%   ag = anaglyph(left, right, colors)
%   ag = anaglyph(stereopair, colors)
%
%  colors is a string wth 2 letters, the first for left, the second 
%  for right, and each is one of:
%    r   red
%    g   green
%    b   green
%    c   cyan
%    m   magenta
%
%   ag = anaglyph(left, right, colors, disp)
%   ag = anaglyph(stereopair, colors, disp)
%
% disp allows for disparity correction, if positive the disparity is increased, if negative it
% is reduced.  This is achieved by trimming the images.  Use this option to make the images more
% natural/comfortable to view, useful if the images were achieved with a non-human stereo baseline
% or field of view.

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

function anaglyph = anaglyph(left, right, colors, disp)

    if nargin < 3,
        colors = 'rc';
    end
    if nargin < 4,
        disp = 0;
    end

    % ensure the images are greyscale
    left = imono(left);
    right = imono(right);

    [height,width] = size(left);
    if disp > 0,
        left = left(:,1:width-disp);
        right = right(:,disp+1:end);
    end
    if disp < 0,
        disp = -disp;
        left = left(:,disp+1:end);
        right = right(:,1:width-disp);
    end

    ag = zeros([size(left) 3]);

    ag = ag_insert(ag, left, colors(1));
    ag = ag_insert(ag, right, colors(2));

    if nargout > 0,
        aglyph = ag;
    else
        if isa(left, 'uint8'),
            ag = ag / 255;
        end
        image(ag);
    end

function out = ag_insert(in, im, c)

    out = in;
    % map single letter color codes to image planes
    switch c,
    case 'r'
        out(:,:,1) = im;        % red
    case 'g'
        out(:,:,2) = im;        % green
    case 'b'
        % blue
        out(:,:,3) = im;
    case 'c'
        out(:,:,2) = im;        % cyan
        out(:,:,3) = im;
    case 'm'
        out(:,:,1) = im;        % magenta
        out(:,:,3) = im;
    case 'o'
        out(:,:,1) = im;        % orange
        out(:,:,2) = im;
    end
