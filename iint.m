%IINT Convert image to integer class
%
%   im = iint(in, class)
%
%   Convert the double precision image to the specificed integer class.
%   In the input image each pixel is in the range 0 to 1.  The integer
%   pixels are scaled to span the range 0 to the maximum value of the
%   integer class, eg.
%
%       im = iint(dim, 'uint8');

function im = iint(in, cls)

    if nargin < 2
        cls = 'uint8';
    end

    im = cast(round( in * double(intmax(cls))), cls);
