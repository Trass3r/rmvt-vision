function ishowmatch(m, im1, kp1, im2, kp2)

    clf

    image([im1 im2]*255)
    w = numcols(im1);

    hold on
    for k=1:numrows(m.correspond),
        m1 = m.correspond(k,1);
        m2 = m.correspond(k,2);

        if m.strength(k) < 0.10,
            continue;
        end



        plot([kp1.x(m1) kp2.x(m2)+w], [kp1.y(m1) kp2.y(m2)], 'g-');
    end
    hold off

