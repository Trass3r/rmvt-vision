%ScaleCornerFeature  Corner feature object
%
% A superclass for image corner features.

classdef ScaleCornerFeature < CornerFeature

    properties
        scale
    end % properties

    methods
        function f = ScaleCornerFeature(varargin)
            f = f@CornerFeature(varargin{:});  % invoke the superclass constructor
        end

        function val = scale_v(features)
            val = [features.scale];
        end


        % accepts all the same options as imarker, first option must be the fill color
        function plot_scale(features, varargin)
            arglist = {};

            argc = 1;
            opt.display = 'circle';
            while argc <= length(varargin)
                switch lower(varargin{argc})
                case 'circle'
                    opt.display = varargin{argc};
                case 'disk'
                    opt.display = varargin{argc};
                otherwise
                    arglist = [arglist varargin(argc)];
                end
                argc = argc + 1;
            end

            holdon = ishold;
            hold on

            switch (opt.display)
            case 'circle'
                circle([ [features.u]', [features.v]' ], [features.scale]', arglist{:});
            case 'disk'
                for f=features
                    f
                    imarker( [f.u f.v], 'circle', 'size', f.scale, ...
                        'fillcolor', arglist{:});
                end
            end
            if ~holdon
                hold off
            end
        end % plot

    end % methods
end % classdef
