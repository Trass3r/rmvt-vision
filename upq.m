function m = upq(im, p, q)

    [X,Y] = imeshgrid(im);

	m00 = mpq(im, 0, 0);
	xc = mpq(im, 1, 0) / m00;
	yc = mpq(im, 0, 1) / m00;

    m = sum(sum( im.*(X-xc).^p.*(Y-yc).^q ) );
