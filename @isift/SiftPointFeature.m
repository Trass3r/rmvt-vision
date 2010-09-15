%SiftCornerFeature  SIFT Corner feature object
%
% A superclass for image corner features.

classdef SiftPointFeature < ScalePointFeature

    properties
        theta_
        image_id_
    end % properties

    methods
        function f = SiftPointFeature(varargin)
            f = f@ScalePointFeature(varargin{:});  % invoke the superclass constructor
        end

        function val = theta_v(features)
            val = [features.theta];
        end

        function val = theta(features)
            val = [features.theta_];
        end

        function val = image_id(features)
            val = [features.image_id_];
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
                case 'clock'
                    opt.display = varargin{argc};
                case 'disk'
                    opt.display = varargin{argc};
                case 'arrow'
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
                circle([ [features.u_]', [features.v_]' ], [features.scale_]', arglist{:});
            case 'clock'
                circle([ [features.u_]', [features.v_]' ], [features.scale_]', arglist{:});
                for f=features
                    plot([f.u_, f.u_+f.scale_*cos(f.theta_)], ...
                        [f.v_, f.v_+f.scale_*sin(f.theta_)], ...
                        arglist{:});
                end
            case 'disk'
                for f=features
                    imarker( [f.u_ f.v_], 'circle', 'size', f.scale_, ...
                        'fillcolor', arglist{:});
                end
            case 'arrow'
                for f=features
                    quiver(f.u_, f.v_, f.scale_.*cos(f.theta_), ...
                            f.scale_.*sin(f.theta_), arglist{:});
                end
            end
            if ~holdon
                hold off
            end
        end % plot

        function [m,corresp] = match(f1, f2)

            [matches,dist] = siftmatch([f1.descriptor], [f2.descriptor]);

            % matches is a 2xM matrix, one column per match, each column is the index of the
            % matching features in image 1 and 2 respectively
            % dist is a 1xM matrix of distance between the matched features, low is good.

            % sort into increasing distance
            [z,k] = sort(dist, 'ascend');
            matches = matches(:,k);
            dist = dist(:,k);

            m = [];
            cor = [];

            for i=1:numcols(matches),
                k1 = matches(1,i);
                k2 = matches(2,i);
                mm = FeatureMatch(f1(k1), f2(k2), dist(i));
                m = [m mm];
                cor(:,i) = [k1 k2]';
            end            

            if nargout > 1
                corresp = cor;
            end
        end


    end % methods

    methods(Static)

        % the MEX functions live in a private subdirectory, so these static methods
        % provide convenient access to them

        function [k,d] = sift(varargin)
            [k,d] = sift(varargin{:});
        end
    end

end % classdef
