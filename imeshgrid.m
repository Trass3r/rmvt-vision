% [U,V] = imeshgrid(image)
% [U,V] = imeshgrid(width, height)

function [U,V] = imeshgrid(a1, a2)

    if nargin == 1
        if ndims(a1) < 2
            error('expecting an image argument');
        end
        [U,V] = meshgrid(1:numcols(a1), 1:numrows(a1));
    elseif nargin == 2
        [U,V] = meshgrid(1:a2, 1:a1);
    end
        
        
