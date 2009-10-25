%IINT Convert double image to integer class
%
%   im = iint(dim, class)
%
%   Convert the double precision image to the specificed integer class.
%   In the input image each pixel is in the range 0 to 1.  The integer
%   pixels are scaled to span the range 0 to the maximum value of the
%   integer class, eg.
%
%       im = iint(dim, 'uint8');

function im = iint(dim, cls)

    if nargin < 2
        cls = 'uint8';
    end

    if isfloat(dim)
        im = cast(round( dim * double(intmax(cls))), cls);
    else
        im = dim;
    end
