function [ri,thi] = boundary(f, varargin)

    dxy = f.edge - ones(numrows(f.edge),1)*[f.xc f.yc];

    r = norm2(dxy')';
    th = -atan2(dxy(:,2), dxy(:,1));
    [th,k] = sort(th, 'ascend');
    plot(th)
    r = r(k);

    if nargout == 0
        plot(dxy(:,1), dxy(:,2), varargin{:});

    else
        thi = [0:399]'/400*2*pi - pi;
        ri = interp1(th, r, thi, 'spline');
    end

