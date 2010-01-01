function c2 = ipaste(c, pattern, topleft, opt)

    [h,w,nc] = size(c);
    [ph,pw,np] = size(pattern);

    if nargin == 4 && strcmp(opt, 'centre')
        % specify centre of pattern not topleft
        left = topleft(1) - floor(pw/2);
        top = topleft(2) - floor(ph/2);
    else
        left = topleft(1);      % x
        top = topleft(2);       % y
    end

    if (top+ph-1) > h
        error('pattern falls off bottom edge');
    end
    if (left+pw-1) > w
        error('pattern falls off right edge');
    end

    if np > nc
        % pattern has multiple planes, replicate the canvas
        c2 = repmat(c, [1 1 np]);
    else
        c2 = c;
    end
    if np < nc
        pattern = repmat(pattern, [1 1 nc]);
    end
    c2(top:top+ph-1,left:left+pw-1,:) = pattern;
        
