function epishow(L, R, F)

    image([L R] * 255.0);
    w = numcols(L);
    colormap(gray(256))

    h = line(0, 0);

    while 1
        [x,y] = ginput(1);
        if isempty(x)
            break;
        end
        x
        y

        if x <= w
            disp('left image');
        else
            disp('right image')
        end

        p = [x y 1]';
        l = F * p;

        x1 = 1;
        x2 = w;

        y1 = (-l(1)*x1 - l(3)) / l(2);
        y2 = (-l(1)*x2 - l(3)) / l(2);

        set(h, 'Xdata', [x1+w x2+w], 'Ydata', [y1 y2]);
    end

