function L = visjac_l(cam, f, plane)

    if numcols(f) > 1
        L = [];
        % recurse for each point
        for i=1:numcols(f)
            L = [L; cam.visjac_l(f(:,i), plane(:,i))];
        end
        return;
    end
    
    theta = f(1); rho = f(2);
    sth = sin(theta); cth = cos(theta);

    a = plane(1); b = plane(2); c = plane(3); d = plane(4);

    lam_th = (-a*cth + b*sth ) / d;
    lam_rho = (a*rho*sth + b*rho*cth + c) / d;

    L = [
        lam_th*sth, lam_th*cth,  -rho*lam_th, rho*sth, rho*cth, 1 
        lam_rho*sth, lam_rho*cth, -lam_rho*rho, cth*(1 + rho^2), -sth*(1 + rho^2), 0
    ];



