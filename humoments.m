function phi = humoments(im)

    % second moments
    eta_20 = npq(im, 2, 0);
    eta_02 = npq(im, 0, 2);
    eta_11 = npq(im, 1, 1);

    % third moments
    eta_30 = npq(im, 3, 0);
    eta_03 = npq(im, 0, 3);
    eta_21 = npq(im, 2, 1);
    eta_12 = npq(im, 1, 2);

    phi(1) = eta_20 + eta_02;
    phi(2) = (eta_20 - eta_02)^2 + 4*eta_11^2;
    phi(3) = (eta_30 - 3*eta_12)^2 + (3*eta_21 - eta_03)^2;
    phi(4) = (eta_30 + eta_12)^2 + (eta_21 + eta_03)^2;
    phi(5) = (eta_30 - 3*eta_12)*(eta_30+eta_12)* ...
       ((eta_30 +eta_12)^2 - 3*(eta_21+eta_03)^2) + ...
       (3*eta_21 - eta_03)*(eta_21+eta_03)* ...
       (3*(eta_30+eta_12)^2 - (eta_21+eta_03)^2);
    phi(6) = (eta_20 - eta_02)*((eta_30 +eta_12)^2 - (eta_21+eta_03)^2) + ...
       4*eta_11 *(eta_30+eta_12)*(eta_21+eta_03);
    phi(7) = (3*eta_21 - eta_03)*(eta_30+eta_12)* ...
      ((eta_30 +eta_12)^2 - 3*(eta_21+eta_03)^2) + ...
      (3*eta_12 - eta_30)*(eta_21+eta_03)*( 3*(eta_30+eta_12)^2 - (eta_21+eta_03)^2);

