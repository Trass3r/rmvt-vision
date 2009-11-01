function [z, s] = boundmatch(r1, r2)

    s = mean(r1) / mean(r2);
    r1 = r1/mean(r1);
    r2 = r2/mean(r2);

    for i=1:400
        rr = [r2(end-i+2:end); r2(i:end)];
        z(i) = max( xcorr(r1, rr) );
    end
