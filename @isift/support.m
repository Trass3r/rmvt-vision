function [out,TT] = support(sf, images, N)

    if nargin < 3
        N = 50;
    end

    im = images(:,:,sf.image_id);

    d = 2*sf.scale;

    [Uo,Vo] = imeshgrid(N, N);

    T = se2(sf.u, sf.v, sf.theta) * diag([d/N,d/N,1]) * se2(-N/2, -N/2);

    UV = transformp(T, [Uo(:) Vo(:)]');
    U = reshape(UV(1,:), size(Uo));
    V = reshape(UV(2,:), size(Vo));

    [Ui,Vi] = imeshgrid(im);

    im2 = interp2(Ui, Vi, idouble(im), U, V);

    if nargout == 0
        idisp(im2)
    elseif nargout == 1
        out = im2;
    elseif nargout == 2
        out = im2;
        TT = T;
    end
