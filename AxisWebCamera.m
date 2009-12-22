%AXISWEBCAMERA Class to read from Axis webcam
%
%
% SEE ALSO: Video
%

classdef AxisWebCamera < ImageSource

    properties
        url
        firstImage
    end

    methods

        function wc = AxisWebCamera(url, varargin)

            % invoke the superclass constructor and process common arguments
            wc = wc@ImageSource(varargin);

            % set default size params if not set
            if isempty(wc.width)
                wc.width = 640;
                wc.height = 480;
            end

            wc.url = url;
            wc.firstImage = [];

            try
                wc.firstImage = wc.grab();
            except
                error('cant access specified web cam')
            end
            [height,width] = size(wc.firstImage);
            wc.color = ndims(wc.firstImage) > 2;
        end

        function n = paramSet(wc, args)
            % handle parameters not known to the superclass
            switch lower(args{1})
            case 'resolution'
                res = args{2};
                res
                wc.width = res(1);
                wc.height = res(2);
                n = 1;
            otherwise
                error( sprintf('unknown option <%s>', args{count}));
            end
        end

        function close(m)
        end



        function im = grab(wc)

            if ~isempty(wc.firstImage)
                % on the first grab, return the image we used to test the webcam at
                % instance creation time
                im = wc.convert( wc.firstImage );
                wc.firstImage = [];
                return;
            end

            url = sprintf('%s/axis-cgi/jpg/image.cgi?resolution=%dx%d', wc.url, wc.width, wc.height);
            url
            im = wc.convert( imread(url) );

        end

        function s = char(wc)
            s = '';
            s = strvcat(s, sprintf('Webcam @ %s', wc.url));
            if wc.iscolor()
                s = strvcat(s, sprintf('  %d x %d x 3', wc.width, wc.height));
            else
                s = strvcat(s, sprintf('  %d x %d', wc.width, wc.height));
            end
        end

    end
end
