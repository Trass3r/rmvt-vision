%SiftCornerFeature  SIFT Corner feature object
%
% A superclass for image corner features.

classdef SiftCornerFeature < ScaleCornerFeature

    properties
        theta
    end % properties

    methods
        function f = SiftCornerFeature(varargin)
            f = f@ScaleCornerFeature(varargin{:});  % invoke the superclass constructor
        end

        function val = theta_v(features)
            val = [features.theta];
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
                circle([ [features.u]', [features.v]' ], [features.scale]', arglist{:});
            case 'clock'
                circle([ [features.u]', [features.v]' ], [features.scale]', arglist{:});
                for f=features
                    plot([f.u, f.u+f.scale*cos(f.theta)], ...
                        [f.v, f.v+f.scale*sin(f.theta)], ...
                        arglist{:});
                end
            case 'disk'
                for f=features
                    imarker( [f.u f.v], 'circle', 'size', f.scale, ...
                        'fillcolor', arglist{:});
                end
            case 'arrow'
                for f=features
                    quiver(f.u, f.v, f.scale.*cos(f.theta), ...
                            f.scale.*sin(f.theta), arglist{:});
                end
            end
            if ~holdon
                hold off
            end
        end % plot

        function [m,corresp] = match(f1, f2)

            m = matchobj;

            %m.image1 = f1.image;
            %m.image2 = f2.image;

            [matches,d] = siftmatch([f1.descriptor], [f2.descriptor]);

            % build the vector of matching coordinates
            m.xy = zeros(numcols(matches), 4);
            
            for i=1:numrows(m.xy),
                k1 = matches(1,i);
                k2 = matches(2,i);
                m.xy(i,:) = [f1(k1).u f1(k1).v f2(k2).u f2(k2).v];
                cor(i,:) = [k1 k2];
            end            
            [m.strength,k] = sort(d', 1, 'ascend');
            cor = cor(k,:);
            
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
