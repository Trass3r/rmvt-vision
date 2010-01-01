function w = homwarp(im, H)

    [Up,Vp] = imeshgrid(im);

    uv = homtrans(inv(H), [Up(:) Vp(:)]');

    U = reshape(uv(1,:), size(Up));
    V = reshape(uv(2,:), size(Vp));
    imh = interp2(Up, Vp, imono(im), U, V);       

    if nargout > 0
        w = imh;
    else
        idisp(imh);
    end
