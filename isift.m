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

function f = isift(im, varargin)

    if iscell(im)
        f = {};
        for i=1:length(im)
            f{i} = isift(im{i}, varargin{:});
        end
        return
    end
    [k,d] = SiftCornerFeature.sift(im, varargin{:});

    % k has 1 column per feature, the rows are: x, y, scale, theta
    % d has 1 column per feature, 128 elements

    nfeat = numcols(k);

    % allocate storage for the objects
    f(nfeat) = SiftCornerFeature();

    for i=1:nfeat
        f(i).u = k(1,i);
        f(i).v = k(2,i);
        f(i).strength = k(5,i);  % no strength returned
        f(i).scale = 1.5*4*k(3,i);
        f(i).theta = k(4,i)';
        f(i).descriptor = d(:,i);
    end

    % sort into descending order
    [z,k] = sort(-[features.strength]);
    features = features(k);
