function s = ktriangle(sz)

    sz
    if numel(sz) == 1
        w = bitor(sz, 1);  % make it odd
        h = w;
        s = zeros(w, w);

        w2 = ceil(w/2);
        h2 = w2;
    elseif numel(w) == 2
        w = bitor(sz(1), 1);  % make it odd
        h = bitor(sz(2), 1);  % make it odd
        s = zeros(h, w);

        w2 = ceil(w/2);
        h2 = ceil(h/2);
    end

    for i=1:w
        if i>w2
            y = round( ((h-1)*i + w - w2*h) /(w-w2) );
            s(y:h,i) = 1;
        else
            y = round( ((h-1)*i + 1 - w2*h) /(1-w2) );
            s(y:h,i) = 1;
        end
    end
