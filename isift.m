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

function features = isift(im, varargin)

    opt.suppress = 0;
    opt.nfeat = Inf;
    opt.supress = 0;

    [opt,arglist] = tb_optparse(opt, varargin);

    if iscell(im)
        % images provided as a cell array, return a cell array
        % of SIFT object vectors
        fprintf('extracting SIFT features for %d greyscale images\n', length(im));
        features = {};
        for i=1:length(im)
            sf = isift(im{i}, 'setopt', opt);
            for j=1:length(sf)
                sf(j).image_id = i;
            end
            features{i} = sf;
            fprintf('.');
        end
        fprintf('\n');
        return
    end

    % convert color image to greyscale
    if ndims(im) ==3 && size(im, 3) == 3
       im = imono(im);
    end

    if ndims(im) > 2

        % TODO sequence of color images..

        % images provided as an array, return a cell array
        % of SIFT object vectors
        if opt.verbose
            fprintf('extracting SIFT features for %d greyscale images\n', size(im,3));
        end
        features = {};
        for i=1:size(im,3)
            sf = isift(im(:,:,i), 'setopt', opt);
            for j=1:length(sf)
                sf(j).image_id_ = i;
            end
            features{i} = sf;
            fprintf('.');
        end
        if opt.verbose
            fprintf('\n');
        end
        return
    end


    % do SIFT using a static method that wraps the implementation
    [key,desc] = SiftPointFeature.sift(im, arglist{:});

    % key has 1 column per feature, the rows are: x, y, scale, theta, strength
    % desc has 1 column per feature, 128 elements

    fprintf('%d corners found (%.1f%%), ', numcols(key), ...
        numcols(key)/prod(size(im))*100);

    % sort into descending order of corner strength
    [z,k] = sort(key(5,:), 'descend');
    key = key(:,k);
    desc = desc(:,k);

    % allocate storage for the objects
    n = min(opt.nfeat, numcols(key));

    % sort into decreasing strength


    features = [];
    i = 1;
    while i<=n
        if i > numcols(key)
            break;
        end

        % enforce separation between corners
        % TODO: strategy of Brown etal. only keep if 10% greater than all within radius
        if (opt.suppress > 0) && (i>1)
            d = sqrt( ([features.v]'-key(2,i)).^2 + ([features.u]'-key(1,i)).^2 );
            if min(d) < opt.suppress
                continue;
            end
        end
        f = SiftPointFeature(key(1,i), key(2,i), key(5,i));
        f.scale_ = 1.5*4*key(3,i);
        f.theta_ = key(4,i)';
        f.descriptor_ = cast(desc(:,i), 'single');

        features = [features f];
        i = i+1;
    end
    fprintf(' %d corner features saved\n', i-1);
