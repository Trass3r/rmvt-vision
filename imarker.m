% Parameters are specified as string options or string/value pairs:
%
%   'circle'        draw a circular marker (default)
%   'box'           draw a square marker
%   'size', sz      radius of circle, or half-side length of a square
%
%   'color', cs     draw the outline of the marker in color cs
%   'thick', thick  line thickness in points (default 0.5)
%   'fillcolor', cs draw a filled marker in color cs
%   'alpha', alpha  set transparency of the filled marker and edge, in the range 0 to 1
%
%   'number'        number the markers sequentially
%   'label', labl   label the markers with the strings from cell array labl, of the
%                   same length as uv
%   'fontsize', fs  fontsize, specified as a fraction (0 to 1) of the figure size
%   'fontcolor', cs font color
%   'bold'          draw text in bold font
%
% If only 'color' is given an outline of the marker shape is drawn
% If only 'fillcolor' is given a filled marker shape is drawn
% If both 'color' and 'fillcolor' are given a filled marker shape with edge is drawn, edge
%   and face can be different colors.
% If neither 'color' and 'fillcolor' are given a default marker is used.
%
% cs is a standard colorspec such as 'b' or [0 0 1]
% supersedes markfeature, addcircle
function h = imarker(uv, varargin)

    opt = [];
    opt.size = [];
    opt.color = [];
    opt.alpha = 1;
    opt.fillcolor = [];
    opt.label = [];
    opt.thick = 0.5;
    opt.number = false;
    opt.fontsize = 0.02;
    opt.fontcolor = 'k';
    opt.bold = false;
    opt.shape = 'circle';

    argc = 1;
    while argc <= length(varargin)
        switch lower(varargin{argc})
        case {'circle', 'box'}
            opt.shape = lower(varargin{argc});
        case 'color'
            % edge color
            opt.color = varargin{argc+1}; argc = argc+1;
        case 'fillcolor'
            % face color
            opt.fillcolor = varargin{argc+1}; argc = argc+1;
        case 'alpha'
            % face alpha/transparency
            opt.alpha = varargin{argc+1}; argc = argc+1;
        case 'thick'
            opt.thick = varargin{argc+1}; argc = argc+1;
        case 'size'
            opt.size = varargin{argc+1}; argc = argc+1;
        case 'label'
            % labels for features
            opt.label = varargin{argc+1}; argc = argc+1;
        case 'number'
            opt.number = true;
        case 'bold'
            opt.bold = true;
        case 'fontsize'
            opt.fontsize = varargin{argc+1}; argc = argc+1;
        case 'fontcolor'
            opt.fontcolor = varargin{argc+1}; argc = argc+1;
        otherwise
            error( sprintf('unknown option <%s>', varargin{argc}));
        end
        argc = argc + 1;
    end

    opt

    % hold logic
    ih = ishold;
    hold on

    % create the outline of the marker
    switch opt.shape
    case 'circle'
        n = 100;

        th = [0:n]'/n*2*pi;
        x = opt.size*cos(th);
        y = opt.size*sin(th);

    case 'box'
        x = [opt.size opt.size -opt.size -opt.size opt.size]';
        y = [opt.size -opt.size -opt.size opt.size opt.size]';

    end


    if isempty(opt.size)
        error('must specify marker size');
    end

    % color  facecolor
    %  N        N         default
    %  Y        N         outline only
    %  N        Y         fillcolor, no edge color
    %  Y        Y         fillcolor, with edge color

    if isempty(opt.color) && isempty(opt.fillcolor)
        % set default marker parameters
        opt.color = 'r';
        opt.fillcolor = 'r';
        opt.alpha = 0.5;
    elseif ~isempty(opt.color) && isempty(opt.fillcolor)
        color = opt.color;
        args = {'FaceColor', 'none', 'EdgeColor', color, 'LineWidth', opt.thick};
    elseif isempty(opt.color) && ~isempty(opt.fillcolor)
        color = opt.fillcolor;
        args = {'EdgeColor', 'none'};
    elseif ~isempty(opt.color) && ~isempty(opt.fillcolor)
        color = opt.fillcolor;
        args = {'EdgeColor', opt.color, 'LineWidth', opt.thick};
    end
    args = [args, 'FaceAlpha', opt.alpha, 'EdgeAlpha', opt.alpha];

    handles = [];   % list of handles for circles
    for i=1:numrows(uv)
        c = uv(i,:);
        handles = [handles; patch(x+c(1), y+c(2), color, args{:})];

        if opt.number
            label = sprintf('  %d', i);
        end
        if ~isempty(opt.label)
            label = sprintf('  %s', opt.label{i});
        end
        if opt.number || ~isempty(opt.label)
            if opt.bold
                weight = 'bold';
            else
                weigth = 'normal';
            end
			text(c(1)+opt.size, c(2), label, ...
                'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'middle', ...
				'FontUnits', 'normalized', ...
				'FontSize', opt.fontsize, ...
                'FontWeight', weight, ...
				'Color', opt.fontcolor);
        end
    end

    if ih == 0,
        hold off
    end

    if nargout > 0,
        h = handles;
    end
