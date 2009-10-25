%IDOUBLE Convert integer image to double
%
%   dim = idouble(im)
%
%   Convert the integer image to a double precision image where
%   each pixel is in the range 0 to 1.  The integer pixels are 
%   assumed to span the range 0 to the maximum value of the
%   integer class.
%

function dim = idouble(im)

    if isinteger(im)
        dim = double(im) / double(intmax(class(im)));
    elseif islogical(im)
        dim = double(im);
    else
        dim = im;
    end
