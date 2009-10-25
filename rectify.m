function imr = rectify(F, L)

    
    % set the center of the transform
    x0 = [numcols(L) numrows(L)] / 2;
    T = [1 0 -x0(1); 0 1 -x0(2); 0 0 1]
    T

    disp('original epipole');
    eh = null(F);
    e = h2e(eh)

    disp('translated epipole');
    eth = T*eh;
    e = h2e(eth)

    tt = -(e(2)) / (e(1));
    ct = cos(atan(tt));
    R = [1 -tt 0 ; tt 1 0; 0 0 1/ct];
    R

    disp('translated rotated epipole')
    erth = R*eth;
    e = h2e(erth)

    f = e(1)
    G = [1 0 0; 0 1 0; -1/f 0 1];

    H = G * R * T;
    
    imr = imTrans(L, H);
    idisp(imr);

    eph = null(F');


end
