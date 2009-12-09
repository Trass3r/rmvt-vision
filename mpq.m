function m = mpq(im, p, q)

    [X,Y] = imeshgrid(im);

    m = sum(sum( im.*X.^p.*Y.^q ) );
