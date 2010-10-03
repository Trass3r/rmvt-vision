%PointFeature  PointCorner feature object
%
% A superclass for image corner features.

classdef PointFeature < handle

    properties %(GetAccess=protected)%, Hidden=true)
        u_           % feature x-coordinates
        v_           % feature y-coordinates
        strength_
        descriptor_
    end % properties

    methods

        function f = PointFeature(u, v, strength)
            if nargin == 0
                return;
            end
            if nargin >= 2
                f.u_ = u;
                f.v_ = v;
            end
            if nargin == 3
                f.strength_ = strength;
            end
        end

        function val = u(f)
            val = [f.u_];
        end

        function val = v(f)
            val = [f.v_];
        end

        function val = p(f)
            val = [[f.u_]; [f.v_]];
        end

        function val = strength(f)
            val = [f.strength_];
        end

        function val = descriptor(f)
            val = [f.descriptor_];
        end

        function display(f)
            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            if length(f) > 20
                fprintf('%d features (listing suppressed)\n  Properties:', length(f));
                for property=fieldnames(f)'
                    fprintf(' %s', property{1}(1:end-1));
                end
                fprintf('\n');
            else
                disp( char(f) );
            end
        end % display()

        function ss = char(features)
            ss = [];
            for i=1:length(features)
                f = features(i);
                % display the coordinate
                s = sprintf('  (%g,%g)', f.u_, f.v_);

                % display the other properties
                for property=fieldnames(f)'
                    prop = property{1}; % convert from cell array
                    switch prop
                    case {'u_', 'v_', 'descriptor_'}
                        continue;
                    otherwise
                        val = getfield(f, prop);
                        if ~isempty(val)
                            s = strcat(s, [sprintf(', %s=', prop(1:end-1)), num2str(val, ' %g')]);
                        end
                    end
                end

                % do the descriptor last
                val = getfield(f, 'descriptor_');
                if ~isempty(val)
                    if length(val) == 1
                        % only list scalars or shortish vectors
                        s = strcat(s, [', descrip=', num2str(val, ' %g')]);
                    elseif length(val) < 4
                        % only list scalars or shortish vectors
                        s = strcat(s, [', descrip=(', num2str(val', ' %g'), ')']);
                    else
                        s = strcat(s, ', descrip= ..');
                    end
                end
                ss = strvcat(ss, s);
            end
        end

        function val = uv(features)
            val = [[features.u]; [features.v]];
        end

        % f.plot()
        % f.plot(linespec)
        function plot(features, varargin)
            holdon = ishold;
            hold on

            if nargin == 1
                varargin = {'ws'};
            end

            for i=1:length(features)
                plot(features(i).u_, features(i).v_, varargin{:});
            end

            if ~holdon
                hold off
            end
        end % plot

        function s = similarity(f1, f2)
            for i=1:length(f2)
                s(i) = norm(f1.descriptor-f2(i).descriptor);
            end
        end

        function s = ncc(f1, f2)
            for i=1:length(f2)
                s(i) = dot(f1.descriptor,f2(i).descriptor);
            end
        end

        function [m,corresp] = match(f1, f2)

        % TODO: extra args for distance measure, could be ncc, pass through to closest
        % allow threshold, percentage of max

            [corresp, dist]  = closest([f1.xy_], [f2.xy_]);

            % sort into increasing distance
            [z,k] = sort(dist, 'ascend');
            corresp = corresp(:,k);
            dist = dist(:,k);

            m = [];
            cor = [];

            for i=1:numcols(corresp),
                k1 = i;
                k2 = corresp(i);
                mm = FeatureMatch(f1(k1), f2(k2), dist(i));
                m = [m mm];
                cor(:,i) = [k1 k2]';
            end            

            if nargout > 1
                corresp = cor;
            end
        end

    end % methods
end % classdef
