%FEATURES
%
% A superclass for image corner features.

classdef features

    properties
        x           % vector of feature x-coordinates
        y           % vector of feature y-coordinates
        image       % the original image
    end % properties

    methods

        function v = length(f)
            v = length(f.x);
        end % length

        function display(f)
            disp(' ');
            disp([inputname(1), ' = '])
            disp(' ');
            disp( char(f) );
        end % display()

        function s = char(f)
            s = sprintf('%d features\n', length(f.x));
        end


        function plot(f, varargin)
            image(f.image*255)
            colormap(gray(256));
            markfeatures([f.x f.y], varargin{:});
        end % plot
    end % methods

end
