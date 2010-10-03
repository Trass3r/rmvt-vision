function ianimate(im, varargin)

    points = [];
    opt.fps = 5;
    opt.loop = false;
    opt.npoints = 100;
    opt.only = [];

    [opt, arglist]  = tb_optparse(opt, varargin);

    if length(arglist) >= 1 && iscell(arglist(1))
        points = arglist{1};
        arglist = arglist(2:end);
    end
    
    clf
    pause on
    colormap(gray(256));

    while true
        for i=1:size(im,3)
            if opt.only ~= i
                continue;
            end
            image(im(:,:,i), 'CDataMapping', 'Scaled');
            if ~isempty(points)
                f = points{i};
                n = min(opt.npoints, length(f));
                f(1:n).plot(arglist{:});
            end
            title( sprintf('frame %d', i) );

            if opt.only == i
                return;
            end
            pause(1/opt.fps);
        end

        if ~opt.loop
            break;
        end
   end
