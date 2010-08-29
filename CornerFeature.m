%CornerFeature  Corner feature object
%
% A superclass for image corner features.

classdef CornerFeature < handle

    properties
        u           % feature x-coordinates
        v           % feature y-coordinates
        strength
        descriptor
    end % properties

    methods

        function f = CornerFeature(u, v, strength)
            if nargin == 0
                return;
            end
            if nargin >= 2
                f.u = u;
                f.v = v;
            end
            if nargin == 3
                f.strength = strength;
            end
        end

        function display(f)
            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            if length(f) > 20
                disp(sprintf('%d features (listing suppressed), properties:\n', length(f)));
                for property=fieldnames(f)'
                    fprintf('  %s\n', property{1});
                end
            else
                disp( char(f) );
            end
        end % display()

        function ss = char(features)
            ss = [];
            for i=1:length(features)
                f = features(i);
                % display the coordinate
                s = sprintf('  (%g,%g)', f.u, f.v);

                % display the other properties
                for property=fieldnames(f)'
                    prop = property{1}; % convert from cell array
                    switch prop
                    case {'u', 'v', 'descriptor'}
                        continue;
                    otherwise
                        val = getfield(f, prop);
                        if ~isempty(val)
                            s = strcat(s, [sprintf(', %s=', prop), num2str(val, ' %g')]);
                        end
                    end
                end

                % do the descriptor last
                val = getfield(f, 'descriptor');
                if ~isempty(val)
                    if length(val) == 1
                        % only list scalars or shortish vectors
                        s = strcat(s, [', descriptor=', num2str(val, ' %g')]);
                    elseif length(val) < 4
                        % only list scalars or shortish vectors
                        s = strcat(s, [', descriptor=(', num2str(val', ' %g'), ')']);
                    else
                        s = strcat(s, ', descriptor= ..');
                    end
                end
                ss = strvcat(ss, s);
            end
        end

        function val = uv(features)
            val = [[features.u]; [features.v]];
        end

        function val = uv_v(features)
            val = [[features.u]; [features.v]];
        end

        function val = strength_v(features)
            val = [features.strength];
        end

        function val = descriptor_v(features)
            val = [features.descriptor];
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
                plot(features(i).u, features(i).v, varargin{:});
            end

            if ~holdon
                hold off
            end
        end % plot

        function m = match(f1, f2)

            m = matchobj;

            %[matches,d] = siftmatch(f1.descriptor, f2.descriptor);

            % build the vector of matching coordinates
            m.xy = zeros(numcols(matches), 4);
            for i=1:numrows(m.xy),
                k1 = matches(1,i);
                k2 = matches(2,i);
                m.xy(i,:) = [f1.x(k1) f1.y(k1) f2.x(k2) f2.y(k2)];
            end
            m.strength = d';
        end

    end % methods
end % classdef
