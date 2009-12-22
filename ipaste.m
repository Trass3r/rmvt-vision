function c2 = ipaste(c, pattern, topleft)

    % TODO: should work if c and/or pattern are color 

    [h,w,nc] = size(c);
    [ph,pw,np] = size(pattern);
    left = topleft(1);      % x
    top = topleft(2);       % y

    [top left w h pw ph]
    if (top+ph > h) || (left+pw) > w
        error('pattern falls off edge');
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
        
