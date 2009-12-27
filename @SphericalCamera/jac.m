function d = jac(theta, phi, r)

    if numcols(theta) > 1
        d = [];
        for i = 1:numcols(theta)
            f = theta(:,i);
            z = phi(i);
            d = [d; jac(f(1), f(2), z)];
        end
        return;
    end

    cp = cos(phi); sp = sin(phi);
    ct = cos(theta); st = sin(theta);

    d = -[cp*ct/r sp*ct/r -st/r -sp cp 0
    -sp/r/st cp/r/st 0 -cp*ct/st -sp*ct/st 1];
