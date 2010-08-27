function out = iconcat(images, dir, bgval)
   % image is a cell array
    width = 0;
    height = 0;
    
    if nargin < 2
        dir = 'h';
    end
    if nargin < 3
        bgval = NaN;
    end
    
    for i=1:length(images)
        if dir == 'v'
            images{i} = images{i}';
        end
        
        image = images{i};

        [nr,nc] = size(image);
        width = width + nc;
        height = max(height, nr);
        ud.widths(i) = width;
    end
    composite = bgval*ones(height, width);

    u = 1;
    for i=1:length(images)
        composite = ipaste(composite, images{i}, [u 1]);
        u = u + size(images{i}, 2);
    end
    
    if dir == 'v'
        composite = composite';
    end
        
    
    if nargout == 0
        idisp(composite)
    else
        out = composite;
    end