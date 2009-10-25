%IISUM Sum of integral image
%
%  s = iisum(ii, r1, r2, c1, c2)
%
%  equivalent to
%   s = iisum( intimage(i), r1, r2, c1, c2);
%   s = sum(sum(i(r1:r2,c1:c2)));
function s = iisum(ii, r1, r2, c1, c2)

    r1 = r1 - 1;
    if r1 < 1
        sA = 0;
        sB = 0;
    else
        sB = ii(r1,c2);
    end
    c1 = c1 - 1;
    if c1 < 1
        sA = 0;
        sC = 0;
    else
        sC = ii(r2,c1);
    end
    if (r1 >= 1) && (c1 >= 1)
        sA = ii(r1,c1);
    end

    s = ii(r2,c2) + sA -sB - sC;


