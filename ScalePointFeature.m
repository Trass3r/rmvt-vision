%ScalePointFeature  Point feature object
%
% A superclass for image corner features.

classdef ScalePointFeature < PointFeature

    properties
        scale_
    end % properties

    methods
        function f = ScalePointFeature(varargin)
            f = f@PointFeature(varargin{:});  % invoke the superclass constructor
        end

        function val = scale(features)
            val = [features.scale_];
        end


        % accepts all the same options as imarker, first option must be the fill color
        function plot_scale(features, varargin)

            opt.display = {'circle', 'disk'};
            [opt,arglist] = tb_optparse(opt, varargin);

            holdon = ishold;
            hold on

            switch (opt.display)
            case 'circle'
                circle([ [features.u_]', [features.v_]' ], [features.scale_]', arglist{:});
            case 'disk'
                for f=features
                    imarker( [f.u; f.v], 'circle', 'size', f.scale, ...
                        'fillcolor', arglist{:});
                end
            end
            if ~holdon
                hold off
            end
        end % plot

    end % methods
end % classdef
