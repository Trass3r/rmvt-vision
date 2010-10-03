function features = iscalemax(L, sscale)

    allmax = zeros(size(L));
    nbmax = zeros(size(L));
    se_all = ones(3,3);
    se_nb = se_all; se_nb(2,2) = 0;

    % get maxima at each level
    for k=1:size(L,3)
        allmax(:,:,k) = imorph(abs(L(:,:,k)), se_all, 'max', 'replicate');
        nbmax(:,:,k) = imorph(abs(L(:,:,k)),  se_nb, 'max', 'replicate');
    end

    z = zeros(size(L,1), size(L,2));
    fc = 1;
    strength = zeros(size(L,1), size(L,2));
    for k=2:size(L,3)-1     % maxima cant be at either end of the scale range
        s = abs(L(:,:,k));
        corners = find( s > nbmax(:,:,k) & s > allmax(:,:,k-1) & s > allmax(:,:,k+1) );
        for corner=corners'
            [y,x] = ind2sub(size(s), corner);
            features(fc) = ScalePointFeature(x, y, s(corner));
            features(fc).scale_ = sscale(k)*sqrt(2);
            fc = fc+1;
        end
    end

    % sort into descending order of strength
    [z,k] = sort(-features.strength);
    features = features(k);
