function [all,nsets] = mser(im, varargin)
    if size(im,3) > 1
        error('monochrome images only');
    end

    % process the argument list.
    %  we add two arguments 'light', 'dark' for the wrapper, the rest get
    % get passed to MSER.
    argc = 1;
    invert = true;
    mser_args = {};
    while argc <= length(varargin)
        switch lower(varargin{argc})
        case 'dark'
            invert = false;
        case 'light'
            invert = true;
        otherwise
            % pass through to MSER
            mser_args = [mser_args varargin{argc}];
        end
        argc = argc + 1;
    end

    % MSER operates on a uint8 image
    if isfloat(im)
        if invert
            im = 1.0-im;
        end
        im = iint(im);
    else
        if invert
            im = 255-im;
        end
    end

    % add default args if none given
    mser_args
    if isempty(mser_args)
        mser_args = {'MinArea', 0.0001, 'MaxArea', 0.1};
    end
    mser_args


    [R,F] = vl_mser(im, mser_args{:});
    fprintf('%d MSERs found\n', length(R));

    f1
    idisp(im);

    all = zeros( size(im));
    count = 1;
    for r=R'
        bim = im <= im(r);
        % HACK bim = im <= im(r);
        lim = ilabel(bim);
        mser_blob = lim == lim(r);

        %sum(mser_blob(:))

        count
        %idisp(mser_blob)
        all(mser_blob) =  count;
        count = count + 1;
        [row,col] = ind2sub(size(bim), r);
        %hold on
        %plot(col, row, 'g*');
        %pause(.2)
    end
    nsets = count;
