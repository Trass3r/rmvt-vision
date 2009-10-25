%IDISPLABEL  Display an image with mask
%
%  idisplabel(im, labelimage, labels)
%
% Display only those image pixels which belong to a specific class.
%
%  im is a greyscale NxM or color NxMx3 image.  
%  labelimage is NxM and contains integer pixel class labels
%  labels is a scalar or list of class labels
%
%  idisplabel(im, labelimage, labels, bg)
%
%  set non-selected pixels to the color [bg bg bg]
%
% All 
% SEE ALSO: idisp, idisp2, colorize, colorseg


function idisplabel(im, label, select, bg)

    if isscalar(select),
        mask = label == select;
    else
        mask = zeros(size(label));
        for s=select(:)',
            mask = mask | (label == s);
        end
    end
    
    if nargin < 4,
        bg = 1;
    end
    
    if ndims(im) == 3,
        mask = cat(3, mask, mask, mask);
    end
    
    im(~mask) = bg;
    image(im);
    shg