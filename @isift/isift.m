%ISIFT SIFT feature extractor
%
%   kp = isift(im)
%   kp = isift(im, opt)
%
% kp is an array of structures, each of which has elements:
%       x       x-coordinate of feature
%       y       y-coordinate of feature
%       sigma   scale of feature
%       theta   orientation of feature (rad)
%       d       128-element descriptor

classdef isift < FeatureList

    properties
        theta
        descriptor
    end

    methods

        % constructor
        function f = isift(im)

            [k,d] = sift(im);

            f.x = k(1,:)';
            f.y = k(2,:)';
            f.scale = k(3,:)';
            f.theta = k(4,:)';
            f.descriptor = d;

            f.image = im;
        end

        function m = match(f1, f2)

            m = matchobj;

            m.image1 = f1.image;
            m.image2 = f2.image;

            [matches,d] = siftmatch(f1.descriptor, f2.descriptor);

            % build the vector of matching coordinates
            m.xy = zeros(numcols(matches), 4);
            for i=1:numrows(m.xy),
                k1 = matches(1,i);
                k2 = matches(2,i);
                m.xy(i,:) = [f1.x(k1) f1.y(k1) f2.x(k2) f2.y(k2)];
            end
            m.strength = d';
        end

    end
end
