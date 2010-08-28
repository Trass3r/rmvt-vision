function [a,b] = tristim2cc(tri)

    if ndims(tri) < 3
        % each row is R G B or X Y Z

        s = sum(tri')';

        cc = tri(:,1:2) ./ [s s];
        if nargout == 1
            a = cc;
        else
            a = cc(:,1);
            b = cc(:,2);
        end
    else

        s = sum(tri, 3);

        if nargout == 1
            a = tri(:,:,1:2) ./ cat(3, s, s);
        else
            a = tri(:,:,1) ./ s;
            b = tri(:,:,2) ./ s;
        end
    end
