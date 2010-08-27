function hm = hitormiss(A, S1, S2)
    
    if nargin == 2
        S2 = double(S1 == 0);
        S1 = double(S1 == 1);
    end
    hm = imorph(A, S1, 'min') & imorph((1-A), S2, 'min');
