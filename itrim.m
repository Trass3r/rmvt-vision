function [out1,out2] = itrim(in1, in2, thresh)

    if nargin < 3
        thresh = 0.75;
    end
    
    out1 = trimx(in1, thresh);
    out2 = trimx(in2, thresh);
    
    z = iconcat({out1, out2});
    
    z = trimy(z, thresh);
    
    w1 = size(out1, 2);
    
    out1 = z(:,1:w1);
    out2 = z(:,w1+1:end);
    
    [w1,h1] = isize(out1);
    [w2,h2] = isize(out2);
    
    if w1 > w2
        out1 = out1(:,1:w2);
    else
        out2 = out2(:,1:w1);   
    end
    
end
    
    
    function out = trim(in, thresh)

        out = trimx(in, thresh);


        out = trimy(out, t);
    end

    
    function out = trimx(in, thresh)
        % trim contiguous edge columns that are mostly NaN
        t = sum(isnan(in)) > thresh*size(in,1);
        
        out = in;
        n = chunk(t);
        if n > 0
            out = out(:,n+1:end);
        end
        
        n = chunk(t(end:-1:1));
        if n > 0
            out = out(:,1:end-n);
        end
    end

    function out = trimy(in, thresh)
        out = trimx(in', thresh)';
    end

    function n = chunk(t)
        n = 0;
        for i=t(:)'
            if i == 0
                break;
            else
                n = n + 1;
            end 
        end
    end

