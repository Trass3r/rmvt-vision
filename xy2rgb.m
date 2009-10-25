function rgb = xy2rgb(xy)

    x = xy(:,1);
    y = xy(:,2);

    Y = ones(size(x));
    X = x ./ y;
    Z = (ones(size(x)) - x - y) ./ y;


    rgb = xyz2rgb([X Y Z]);

