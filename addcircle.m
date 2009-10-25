%ADDCIRCLE  Add a circle to the current plot
%
%   addcircle(center, radius)
%   addcircle(center, radius, linestyle)
%
%  Returns the graphics handle for the circle.

function h = addcircle(center, radius, varargin)

	n = 100;

	th = [0:n]'/n*2*pi;
	x = radius*cos(th);
	y = radius*sin(th);

    ih = ishold;
    hold on
	handle = plot(x+center(1), y+center(2), varargin{:});

    if ih == 0,
        hold off
    end

    if nargout > 0,
        h = handle;
    end

