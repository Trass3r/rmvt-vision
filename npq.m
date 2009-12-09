function m = npq(im, p, q)

	if (p+q) < 2,
		error('normalized moments: p+q >= 2');
	end

	g = (p+q)/2 + 1;
	m = upq(im, p, q) / mpq(im, 0, 0)^g;
