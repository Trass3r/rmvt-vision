function rg_addticks(lam1, lam2, lamd)

    if nargin == 0
        lam1 = 460;
        lam2 = 600;
        lamd = 10;
    end

    lambda = [lam1:lamd:lam2];
    rgb = cmfrgb(lambda*1e-9);        
    r = rgb(:,1)./sum(rgb')';    
    g = rgb(:,2)./sum(rgb')';    
    hold on
    plot(r,g, 'o')
    hold off

    for i=1:numcols(lambda)
        text(r(i), g(i), sprintf('  %d', lambda(i)));
    end

