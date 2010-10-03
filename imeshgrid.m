% [U,V] = imeshgrid(image)
% [U,V] = imeshgrid(width, height)
% [U,V] = imeshgrid(size)

function [U,V] = imeshgrid(a1, a2)

    if nargin == 1
        if length(a1) == 1
            % we specified a size for a square output image
            [U,V] = meshgrid(1:a1, 1:a1);
        elseif length(a1) == 2
            % we specified a size for a rectangular output image (w,h)
            [U,V] = meshgrid(1:a1(1), 1:a1(2));
        elseif ndims(a1) >= 2
            [U,V] = meshgrid(1:numcols(a1), 1:numrows(a1));
        else
            error('incorrect argument');
        end
    elseif nargin == 2
        [U,V] = meshgrid(1:a1, 1:a2);
    end
        
        
