function c2 = iline(c, p1, p2, value)

    if nargin < 4
        value = 1;
    end

    points = bresenham(p1, p2);

    c2 = c;
    for point = points'
        c2(point(2), point(1)) = value;
    end
