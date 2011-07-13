%EDGELIST Edge pixels of region
%
% E = EDGELIST(IM, P, OPTIONS) is a list of edge pixels for a region.  IM is a 
% binary image and P=[X,Y] is the coordinate of one point on the perimeter
% of a region. E is a matrix with one column per edge point, and each column
% is an edge point coordinate [X,Y].
% 
% Options::
% 'clockwise'        Follow the perimeter in clockwise direction (default)
% 'anticlockwise'    Follow the perimeter in anti-clockwise direction
%
% Notes::
% - Pixel values of 0 are assumed to be background, non-zero is a region.
% - The given point is always the first element of the edgelist.
% - Direction is with respect to y-axis upward.
% - Where the region touches the edge of the image its edge is considered to be
%   the image edge.
%
% See also IBLOBS.


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

function e = edgelist(im, P, varargin)

    opt.direction = {'clockwise', 'anticlockwise'};
    opt = tb_optparse(opt, varargin);

    if strcmp(opt.direction, 'clockwise')
        neighbours = [1:8]; % neigbours in clockwise direction
    elseif strcmp(opt.direction, 'anticlockwise')
        neighbours = [8:-1:1];  % neigbours in counter-clockwise direction
    end

    P = P(:)';
    P0 = P;     % make a note of where we started
    pix0 = im(P(2), P(1));  % color of pixel we start at

    % find an adjacent point outside the blob
    Q = adjacent_point(im, P, pix0);
    if isempty(Q)
        error('no neighbour outside the blob');
    end

    e = P;  % initialize the edge list

    % these are directions of 8-neighbours in a clockwise direction
    dirs = [-1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1; -1 -1];

    while 1
        % find which direction is Q
        dQ = Q - P;
        for kq=1:8
            if all(dQ == dirs(kq,:))
                break;
            end
        end

        % now test for directions relative to Q
        for j=neighbours
            % get index of neighbour's direction in range [1,8]
            k = j + kq;
            if k > 8
                k = k - 8;
            end

            % compute coordinate of the k'th neighbour
            Nk = P + dirs(k,:);
            try
                if im(Nk(2), Nk(1)) == pix0
                    % if this neighbour is in the blob it is the next edge pixel
                    P = Nk;
                    break;
                end
            end
            Q = Nk;     % the (k-1)th neighbour
        end

        % check if we are back where we started
        if all(P == P0)
            break;
        end

        % keep going, add P to the edgelist
        e = [e P'];
    end
end

function P = adjacent_point(im, seed, pix0)
    % find an adjacent point not in the region
    dirs = [1 0; 0 1; -1 0; 0 -1];
    for d=dirs'
        P = [seed(1)+d(1), seed(2)+d(2)];
        try
            if im(P(2), P(1)) ~= pix0
                return;
            end    
        catch
            % if we get an exception then by definition P is outside the region,
            % since it's off the edge of the image
            return;
        end
    end
    P = [];
end
