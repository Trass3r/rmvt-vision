function o = thin(im, delay)

    % create a binary image
    im = im > 0;
    
    o = im;

    Sa = [0 0 0; NaN 1 NaN; 1 1 1];
    Sb = [NaN 0 0; 1 1 0; NaN 1 NaN];

    o = im;
    while true
        for i=1:4
            r = hitormiss(im, Sa);
            im = im - r;
            r = hitormiss(im, Sb);
            im = im - r;
            Sa = rot90(Sa);
            Sb = rot90(Sb);
        end
        if nargin > 1
            idisp(im);
            pause(delay);
        end
        if all(o == im)
            break;
        end
        o = im;
    end
    o = im;
