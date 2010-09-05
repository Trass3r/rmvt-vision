% bag.occurrences(word)          number of occurreneces of word in bag
% [w,f] = bag.occurrences(word)  return vectors of word
classdef BagOfWords < handle
    properties
        K       % number of clusters
        nstop   % number of stop words

        C

        words
        stopwords
        map

        nimages       % number of images

        features
        wv          % cached word vectors
    end

    properties (Dependent=true)
        wordvectors
    end

    methods
        % bag = BagOfWords(features, K)
        % bag = BagOfWords(features, existingBag)
        function bag = BagOfWords(sf, a1)

            % save the feature vector
            if iscell(sf)
                bag.features = [sf{:}];
            else
                bag.features = sf;
            end
            bag.nimages = max([bag.features.image_id]);

            if isnumeric(a1)
                K = a1;
                % do the clustering
                [bag.C,L] = vl_kmeans([bag.features.descriptor], K, ...
                    'verbose', 'algorithm', 'elkan');

                bag.K = K;
                bag.words = double(L);

            elseif isa(a1, 'BagOfWords')
                oldbag = a1;

                bag.K = oldbag.K;
                bag.stopwords = oldbag.stopwords;

                % cluster using number of words from old bag
                bag.words = closest([bag.features.descriptor], oldbag.C);

                k = find(ismember(bag.words, oldbag.stopwords));

                fprintf('Removing %d SIFT features associated with stop words\n', length(k));

                bag.words(k) = [];
                bag.words = oldbag.map(bag.words);
                bag.features(k) = [];

            end
        end

        % return all features assigned to specified word(s)
        function f = isword(bag, words)
            k = ismember(bag.words, words);
            f = bag.features(k);
        end

        % number of occurrences of specified word across all features
        function n = occurrence(bag, word)
            n = sum(bag.words == word);
        end

        function [all2, S] = remove_stop(bag, nstop)
            % find the stop words and remove them
            % these are the nstop most frequent words

            [w,f] = count_unique(bag.words);
            [f,i] = sort(f, 'descend');
            bag.stopwords = w(i(1:nstop));

            % remove all features that are stop words from L and all
            k = find(ismember(bag.words, bag.stopwords));

            fprintf('Removing %d SIFT features associated with %d most frequent words\n', ...
                length(k), nstop);

            % fix the labels
            b = zeros(1,length(bag.words));
            b(bag.stopwords) = 1;
            bag.map = [1:length(bag.words)] - cumsum(b);

            bag.words(k) = [];
            bag.words = bag.map(bag.words);
            bag.features(k) = [];

        end

        function wv = get.wordvectors(bag)
            if isempty(bag.wv)
                bag.compute_wv();
            end
            wv = bag.wv;
        end

        function set.wordvectors(bag)
        end

        % image-word frequency
        function W = iwf(bag)
            N = bag.nimages;  % number of images
            % Create the word matrix W
            %  each column is an image
            %  each row is a word
            %  each element is the number of occurences of that word in that iamge
            W = [];
            id = [bag.features.image_id];

            nl = bag.K - length(bag.stopwords);

            for i=1:bag.nimages
                % get the words associated with image i
                words = bag.words(id == i);

                % create columns of the W
                [w,f] = count_unique(words);
                v = zeros(nl,1);
                v(w) = f;
                W = [W v];
            end
        end

        function W = compute_wv(bag, bag2)

            if nargin == 2
                Wv = bag2.iwf();
                N = bag2.nimages;
                W = bag.iwf();
            else
                Wv = bag.iwf();
                N = bag.nimages;
                W = Wv;
            end

            Ni = sum( Wv'>0 );

            m = [];
            for i=1:bag.nimages
                % number of words in this image
                nd = sum( W(:,i) );

                % word occurrence frequency
                nid = W(:,i)';

                v = nid/nd .* log(N./Ni);
                m = [m v'];
            end

            if nargout == 1
                W = m;
            else
                bag.wv = m;
            end
        end

        function [w,f] = wordfreq(bag)
            [w,f] = count_unique(bag.words);
        end

        % computer similarity matrix
        function sim = similarity(bag1, bag2)
            wv1 = bag1.wordvectors;
            wv2 = bag2.wordvectors;
            whos
            for i=1:bag1.nimages
                for j=1:bag2.nimages
                    v1 = wv1(:,i); v2 = wv2(:,j);
                    sim(i,j) = dot(v1,v2) / (norm(v1) * norm(v2));
                end
            end
        end

        function display(bag)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(bag))
            if loose
                disp(' ');
            end
        end

        function s = char(bag)
            s = sprintf(...
            'BagOfWords: %d features from %d images\n           %d words, %d stop words\n', ...
                length(bag.features), bag.nimages, ...
                bag.K-length(bag.stopwords), length(bag.stopwords));
        end


        function exemplars(bag, words, images, varargin)

            nwords = length(words);
            gap = 2;

            opt.ncolumns = nwords;
            opt.maxperimage = 2;
            opt.width = 50;

            opt = tb_optparse(opt, varargin);

            Ng = opt.width+gap;
            panel = zeros(nwords*Ng, opt.ncolumns*Ng);
            L = bag.words;

            for i=1:nwords
                % for each word specified
                word = words(i);

                features = all.isword(word);  % find features corresponding to the word

                image_prev = [];
                count = 1;
                for j=1:length(features)
                    % for each instance of that word
                    sf = features(j);

                    % only display one template from each image to show some
                    % variety
                    if sf.image_id == image_prev
                        c = c - 1;
                        if c <= 0
                            continue;
                        end
                    else
                        c = opt.maxperimage;
                    end
                    % extract it from the containing image
                    out = sf.support(images, opt.width);

                    % paste it into the panel
                    panel = ipaste(panel, out, [count-1 i-1]*Ng, 'zero');
                    image_prev = sf.image_id;
                    count = count + 1;
                    if count > opt.ncolumns
                        break;
                    end
                end
            end

            idisp(panel, 'plain');


            for i=1:nwords
                % for each word specified
                word = words(i);
                features = all.isword(word);  % find features corresponding to the word

                image_prev = [];
                count = 1;
                for j=1:length(features)
                    % for each instance of that word
                    sf = features(j);
                    if sf.image_id == image_prev
                        c = c - 1;
                        if c <= 0
                            continue;
                        end
                    else
                        c = opt.maxperimage;
                    end
                    % extract it from the containing image
                    text((count-1)*Ng+gap*2, (i-1)*Ng+3*gap, ...
                        sprintf('%d/%d', word, sf.image_id), 'Color', 'g')
                    image_prev = sf.image_id;
                    count = count + 1;
                    if count > opt.ncolumns
                        break;
                    end
                end
            end

    end
end
