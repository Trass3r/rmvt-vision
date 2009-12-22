%IROI	Extract region of interest from current image figure
%
%	si = IROI(image)
%	[si,region] = IROI(image)
%
%	si = IROI(image,region)
%
%	The first two forms display the image and a rubber band box to
%	allow selection of the region of interest.
%	The selected subimage s output and optionally the coordinates of 
%	the region selected which is of the form [left right; top bottom].
%
%	The last form uses a previously created region matrix and outputs the
%	corresponding subimage.  Useful for chopping the same region out of
%	a different image.
%
%
% SEE ALSO:	image, idisp

% Copyright (C) 1995-2009, by Peter I. Corke
%
% This file is part of The Machine Vision Toolbox for Matlab (MVTB).
% 
% MVTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% MVTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with MVTB.  If not, see <http://www.gnu.org/licenses/>.
function [im, region] = iroi(image, reg, wh)

	if nargin == 3
        xc = reg(1); yc = reg(2);
        w = round(wh(1)/2); h = round(h(2)/2);
		im = image(yc-h:yc+h,xc-w:xc+w,:);
    elseif nargin == 2
		im = image(reg(2,1):reg(2,2),reg(1,1):reg(1,2),:);
	else
		% save old event handlers, otherwise may interfere with
		% other tools operating on the figure, eg. idisp()

		clf
		imagesc(image);

		upfunc = get(gcf, 'WindowButtonUpFcn');
		downfunc = get(gcf, 'WindowButtonDownFcn');
		set(gcf, 'WindowButtonUpFcn', '');
		set(gcf, 'WindowButtonDownFcn', '');

		% get the rubber band box
		waitforbuttonpress
		cp0 = floor( get(gca, 'CurrentPoint') );

		rect = rbbox;	    % return on up click
        
        cp1 = floor( get(gca, 'CurrentPoint') );
        
		%disp('rbbox done, restore handlers');
		% restore event handlers
		set(gcf, 'WindowButtonUpFcn', upfunc);
		set(gcf, 'WindowButtonDownFcn', downfunc);


		ax = get(gca, 'Children');
		img = get(ax, 'CData');			% get the current image

        % determine the bounds of the ROI
        top = cp0(1,2);
		left = cp0(1,1);
		bot = cp1(1,2);
		right = cp1(1,1);
        if bot<top,
            t = top;
            top = bot;
            bot = t;
        end
        if right<left,
            t = left;
            left = right;
            right = t;
        end
        
        % extract the ROI
		im = img(top:bot,left:right,:);
        
        figure
        idisp2(im);
        title(sprintf('ROI (%d,%d) %dx%d', left, top, right-left, bot-top));
        
		if nargout == 2,
			region = [left right; top bot];
		end
	end

