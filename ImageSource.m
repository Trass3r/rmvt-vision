%ImageSource Abstract class for image sources
%
%
% SEE ALSO: Video
%

classdef ImageSource < handle

    properties
        width           % width of each frame
        height          % height of each frame
        rate            % frame rate 
        color           % is a color image

        % options set at construction time
        imageType
        makeGrey
        gamma
        scaleFactor
    end

    methods (Abstract)
        im = grab()
        close()
        char()
        paramSet()
    end

    methods

        function imsource = ImageSource(varargin)

            % set default options
            imsource.imageType = [];
            imsource.makeGrey = false;
            imsource.gamma = [];
            imsource.width = [];
            imsource.height = [];

            args = varargin{:};
            ac = 1;
            while ac<=length(args),
                switch args{ac},
                case 'double',
                    imsource.imageType = 'double';
                case 'float',
                    imsource.imageType = 'float';
                case 'uint8',
                    imsource.imageType = 'uint8';
                case {'grey','gray', 'mono'},
                    imsource.makeGrey = true;
                case 'gamma'
                    imsource.gamma = args{ac+1}; ac = ac+1;
                otherwise,
                    % if the parameter is not known by the base class, call
                    % the parameter handler in the derived class.
                    % it returns the number of additonal parameters consumed.
                    n = imsource.paramSet(args(ac:end));
                    ac = ac + n;
                end
                ac = ac + 1;
            end
    
        end

        function b = iscolor(imsource)
            b = imsource.color;
        end

        function im2 = convert(imsource, im)

            im2 = [];
            % apply options specified at construction time
            if imsource.scaleFactor > 1,
                im2 = im(1:imsource.scaleFactor:end, 1:imsource.scaleFactor:end, :);
            end
            if imsource.makeGrey & (ndims(im) == 3),
                im2 = imono(im);
            end
            if ~isempty(imsource.imageType)
                im2 = cast(im, imsource.imageType);
            end

            if ~isempty(imsource.gamma)
                im2 = igamma(im, imsource.gamma);
            end

            if isempty(im2)
                im2 = im;
            end
        end

        function display(imsource)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(imsource))
            if loose
                disp(' ');
            end
        end
    end
end
