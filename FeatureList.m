%FEATURES
%
% A superclass for image corner features.

classdef FeatureList < handle

    properties
        x           % feature x-coordinates
        y           % feature y-coordinates
        strength    % feature strength
    end % properties

    methods

        function fl = FeatureList(x, y)
            if nargin == 0
                fl.x = [];
                fl.y = [];
                fl.strength = [];
            else
                fl.x = x;
                fl.y = y;
                fl.strength = [];
            end
        end

        function display(f)
            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            if length(f) > 20
                disp(sprintf('%d features (listing suppressed), properties:\n', length(f.x)));
                for property=fieldnames(f)'
                    fprintf('  %s\n', property{1});
                end
            else
                disp( char(f) );
            end
        end % display()

        function ss = char(f)
            ss = [];
            for i=1:length(f)
                s = sprintf('  (%f,%f)', f.x(i), f.y(i));
                for property=fieldnames(f)'
                    prop = property{1};
                    switch prop
                    case {'x', 'y'}
                        continue;
                    otherwise
                        val = builtin('subsref', f, substruct('.', prop, '()', {i, ':'}));
                        if length(val) == 1
                            % only list scalars
                            s = strcat(s, sprintf(', %s=%f', prop, val));
                        end
                    end
                end
                ss = strvcat(ss, s);
            end
        end

        % f.plot
        % f.plot(linespec)
        % f.plot('circle', colorspec)
        % f.plot('disk', colorspec, options)
        % f.plot('arrow', linespec)
        function plot(f, varargin)
            holdon = ishold;
            hold on

            if nargin > 1
                switch (varargin{1})
                case 'circle'
                    try
                        if isempty(f.scale)
                            error('feature has no scale to draw a circle');
                        end
                    catch
                        error('feature has no scale to draw a circle');
                    end
                    circle([f.x, f.y], f.scale, varargin{2:end});
                    try
                        if ~isempty(f.theta)
                            for i=1:numrows(f.x);
                                plot([f.x(i), f.x(i)+f.scale(i)*cos(f.theta(i))], ...
                                    [f.y(i), f.y(i)+f.scale(i)*sin(f.theta(i))], ...
                                    varargin{2:end});
                            end
                        end
                    catch
                        return
                    end
                case 'disk'
                    try
                        if isempty(f.scale)
                            error('feature has no scale to draw a disk');
                        end
                    catch
                        error('feature has no scale to draw a disk');
                    end

                    for i=1:numrows(f.x);
                        imarker([f.x(i), f.y(i)], 'circle', 'size', f.scale(i), 'fillcolor', varargin{:});
                    end
                case 'arrow'
                    try
                        if isempty(f.scale) || isempty(f.theta)
                            error('feature has no scale or theta to draw an arrow');
                        end
                    catch
                        error('feature has no scale or theta to draw an arrow');
                    end
                    quiver(f.x, f.y, f.scale.*cos(f.theta), ...
                            f.scale.*sin(f.theta), varargin{2:end});
                otherwise
                    plot(f.x, f.y, varargin{:});
                end
            else
                % no arguments, default point plot
                for f=f
                    plot(f.x, f.y, 'gs');
                end
            end
            if ~holdon
                hold off
            end
        end % plot

        function l = length(p)
            l = length(p.x);
        end

        % invoked to return the maximum index in eg. A(2:end)
        function l = end(p, k, n)
            l = length(p.x);
        end

        % this function is called on every reference to the object with a dot or ()
        % method calls, property reference or subscript reference
        %
        % this indexing system was designed by a hamster.

        function varargout = subsref(p, S)
            if S(1).type == '.'
                % come here on *any* class method invocation or unsubscripted
                % property reference, eg. obj.method, obj.property, obj()
                if ismethod(p, S(1).subs)
                    % if it was a method call then get Matlab to do it
                    %
                    % but things just get worse (aaaaaargh), we don't know how many
                    % arguments the method will return so we use an ugly trick from
                    % http://blogs.mathworks.com/loren/2009/04/14/convenient-nargout-behavior/
                    [c{1:0}] = builtin('subsref', p, S);
                    if ~isempty(c)
                        for i=1:length(c)
                            varargout{1} = c{1};
                        end
                    end
                else
                    % if it was a property reference, eg. obj.property, obj.prop(a,b)
                    % get Matlab to find the answer, which we return
                    ret = builtin('subsref', p, S);
                end
            elseif strcmp(S(1).type, '()')
                % come here on obj(a), obj(10:12), obj(2:end) etc.
                % we return a new object of the same type, and copy across the specified
                % range of each of its properties

                % first we instantiate a new object of the same type
                varargout{1} = feval( class(p) );

                % for each property
                for prop=fieldnames(p)'
                    % get the specified range from this property
                    try
                        val = builtin('subsref', p, substruct('.', prop,'()', [S.subs {':'}]));
                        % now assign it to the new object with the same property name
                        builtin('subsasgn', ret, substruct('.', prop), val);
                    catch
                        % come here if the element of the class is empty
                        continue
                    end

                end
            end
        end
    end % methods
end % classdef
