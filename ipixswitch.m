function out = ipixswitch(mask, I1, I2)

    if ischar(I1)
        % image is a string color name
        col = colorname(I1);
        if isempty(col)
            error('unknown color %s', col);
        end
        I1 = icolor(ones(size(mask)), col);
    elseif isscalar(I1)
        % image is a scalar, create a greyscale image same size as mask
        I1 = ones(size(mask))*I1;
    elseif ndims(I1) == 2 && all(size(I1) == [1 3])
        % image is 1x3, create a color image same size as mask
        I1 = icolor(ones(size(mask)), I1);
    else
        % actual image, check the dims
        s = size(I1); s = s(1:2);
        if ~all(s == size(mask))
            error('input image sizes do not conform');
        end
    end

    if ischar(I2)
        % image is a string color name
        col = colorname(I2);
        if isempty(col)
            error('unknown color %s', col);
        end
        I2 = icolor(ones(size(mask)), col);
    elseif isscalar(I2)
        % image is a scalar, create a greyscale image same size as mask
        I2 = ones(size(mask))*I2;
    elseif ndims(I2) == 2 && all(size(I2) == [1 3])
        % image is 1x3, create a color image same size as mask
        I2 = icolor(ones(size(mask)), I2);
    else
        % actual image, check the dims
        s = size(I2); s = s(1:2);
        if ~all(s == size(mask))
            error('input image sizes do not conform');
        end
    end

    nplanes = max(size(I1,3), size(I2,3));

    if nplanes == 3
        mask = repmat(mask, [1 1 3]);
        if size(I1,3) == 1
            I1 = repmat(I1, [1 1 3]);
        end
        if size(I2,3) == 1
            I2 = repmat(I2, [1 1 3]);
        end
    end

    % in case one of the images contains NaNs we cant blend the images
    % using arithmetic
    % out = mask .* I1 + (1-mask) .* I2;
    out = I2;
    out(mask) = I1(mask);

    if nargout > 0
        co = out;
    else
        idisp(out);
        shg
    end
