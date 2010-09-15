function [out,u0] = iconcat(images, dir, bgval)
   % image is a cell array
    width = 0;
    height = 0;
    
    if nargin < 2
        dir = 'h';
    end
    if nargin < 3
        bgval = NaN;
    end
    
    np_prev = NaN;
    u0 = 1;
    for i=1:length(images)
        if dir == 'v'
            images{i} = images{i}';
        end
        
        image = images{i};

        [nr,nc,np] = size(image);
        if ~isnan(np_prev) && np ~= np_prev
            error('all images must have same number of planes');
        end
        width = width + nc;
        height = max(height, nr);
        if i > 1
            u0(i) = u0(i-1) + nc;
        end
    end
    composite = bgval*ones(height, width, np);

    u = 1;
    for i=1:length(images)
        composite = ipaste(composite, images{i}, [u 1]);
        u = u + size(images{i}, 2);
    end
    
    if dir == 'v'
        composite = permute(composite, [2 1 3]);
    end
        
    
    if nargout == 0
        idisp(composite)
    else
        out = composite;
    end
