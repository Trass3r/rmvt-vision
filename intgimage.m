function ii = intgimage(I)

    ii = cumsum( cumsum(I)' )';
