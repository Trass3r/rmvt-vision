
% out = ipad(in, sides, n)
%  pad the image with a block of NaNs on the specified sides
%
%  eg.  ipad(im, 't', 20)  block of 20 pixels across the top
%       ipad(im, 'tl', 10) block of 10 pixels across the top and left side
%
% out = ipad(in, sides, n, val)
%  pad with val instead of NaN

function out = ipad(in, sides, n, val)

    if nargin < 4
        val = NaN;
    end
    
    out = in;
    for side=sides
        [w,h] = isize(out);

        switch side
            case 't'
                out = [val*ones(n,w); out];
            case 'b'
                out = [out; val*ones(n,w)];
            case 'l'
                out = [val*ones(h,n) out];
            case 'r'
                out = [out val*ones(h,n)];
        end
    end

                