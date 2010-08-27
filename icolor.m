function c = colorize2(im, color)

    if nargin < 2
        color = [1 1 1];
    end
    c = [];
    for i=1:numel(color)
        c = cat(3, c, im*color(i));
    end
