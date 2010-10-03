function s = iscolor(im)
    s = isnumeric(im) && size(im,1) > 1 && size(im,2) > 1 && size(im,3) == 3;
