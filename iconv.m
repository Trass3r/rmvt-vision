% output is same size as largest input
% handles multiple planes
function C = iconv(A, B, opt)

    if nargin < 3
        opt = 'same';
    end

    if numcols(A) < numcols(B)
        % B is the image
        for k=1:size(B,3)
            C(:,:,k) = conv2(B(:,:,k), A, opt);
        end
    else
        % A is the image
        for k=1:size(A,3)
            C(:,:,k) = conv2(A(:,:,k), B, opt);
        end
    end

