function [o1,o2,o3] = isize(im, idx)

    if nargin == 2
        o1 = size(im, idx);
    else
        s = size(im);
        o1 = s(2);      % width, number of columns
        if nargout > 1
            o2 = s(1);  % height, number of rows
        end
        if nargout > 2
            if ndims(im) == 2
                o3 = 1;
            else
                o3 = s(3);
            end
        end
    end