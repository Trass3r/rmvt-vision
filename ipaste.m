function out = ipaste(canvas, pattern, topleft, varargin)

    [h,w,nc] = size(canvas);
    [ph,pw,np] = size(pattern);

    opt.centre = false;
    opt.zero = false;
    opt.mode = {'set', 'add', 'mean'};

    opt = tb_optparse(opt, varargin);

    if opt.centre
        % specify centre of pattern not topleft
        left = topleft(1) - floor(pw/2);
        top = topleft(2) - floor(ph/2);
    else
        left = topleft(1);      % x
        top = topleft(2);       % y
    end

    if opt.zero
        left = left+1;
        top = top+1;
    end

    if (top+ph-1) > h
        error('pattern falls off bottom edge');
    end
    if (left+pw-1) > w
        error('pattern falls off right edge');
    end

    if np > nc
        % pattern has multiple planes, replicate the canvas
        out = repmat(canvas, [1 1 np]);
    else
        out = canvas;
    end
    if np < nc
        pattern = repmat(pattern, [1 1 nc]);
    end
    switch opt.mode
    case 'set'
        out(top:top+ph-1,left:left+pw-1,:) = pattern;
    case 'add'
        out(top:top+ph-1,left:left+pw-1,:) = out(top:top+ph-1,left:left+pw-1,:) +pattern;
    case 'mean'
        old = out(top:top+ph-1,left:left+pw-1,:);
        k = ~isnan(pattern);
        old(k) = 0.5 * (old + pattern);
        out(top:top+ph-1,left:left+pw-1,:) = old;
    end
