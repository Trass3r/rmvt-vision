%IDISP	Interactive image display tool
%
%	IDISP(image)
%	IDISP(image, options)
%
%   options
%       'signed'
%       'flatten'
%       'colors', N
%
%	Display the image in current figure and create buttons for:
%		* region zooming
%		* unzooming
%		* drawing a cross-section line.  Intensity along line will be
%		  displayed in a new figure.
%
%	Left clicking on a pixel will display its value in a box at the top.
%
%	The second form will limit the displayed greylevels.  If CLIP is a
%	scalar pixels greater than this value are set to CLIP.  If CLIP is
%	a 2-vector pixels less than CLIP(1) are set to CLIP(1) and those
%	greater than CLIP(2) are set to CLIP(2).  CLIP can be set to [] for
%	no clipping.
%	The N argument sets the length of the greyscale color map (default 64).
%
% SEE ALSO:	iroi, image, colormap, gray

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
function idisp(im, varargin)

	if (nargin > 0) & ~isstr(im),
        ncmap = 256;
        argc = 1;
        opt.gui = true;
        opt.axes = true;
        opt.square = false;
        opt.colormap = 'grey';
        opt.print = [];
        while argc <= length(varargin)
            switch lower(varargin{argc})
            case 'colors'
                ncmap = varargin{argc+1}; argc = argc+1;
            case 'nogui'
                opt.gui = false;
            case 'noaxes'
                opt.axes = false;
            case 'square'
                opt.square = true;
            case 'print'
                opt.print = varargin{argc+1}; argc = argc+1;
                opt.gui = false;
            case 'flatten'
                im = reshape( im, size(im,1), size(im,2)*size(im,3) );
            case {'invert', 'signed', 'invsigned'}
                % colormap options
                opt.colormap = lower(varargin{argc});
            otherwise
                error( sprintf('unknown option <%s>', varargin{argc}));
            end
            argc = argc + 1;
        end

		% command line invocation, display the image

        % display the image
		clf
		hi = image(im);
        switch opt.colormap
        case 'grey'
            colormap(gray(ncmap));
        case 'invert'
                % invert the monochrome color map: black <-> white
            cmap = gray(ncmap);
            colormap( cmap(end:-1:1,:) );
        case {'signed', 'invsigned'}
                % signed color map, red is negative, blue is positive, zero is black
                % inverse signed color map, red is negative, blue is positive, zero is white
            cmap = zeros(ncmap, 3);
            ncmap = bitor(ncmap, 1);    % ensure it's odd
            ncm2 = ceil(ncmap/2);
            if strcmp(opt.colormap, 'signed')
                % signed color map, red is negative, blue is positive, zero is black
                for i=1:ncmap
                    if i > ncm2
                        cmap(i,:) = [0 0 1] * (i-ncm2) / ncm2;
                    else
                        cmap(i,:) = [1 0 0] * (ncm2-i) / ncm2;
                    end
                end
            else
                % inverse signed color map, red is negative, blue is positive, zero is white
                for i=1:ncmap
                    if i > ncm2
                        s = (i-ncm2)/ncm2;
                        cmap(i,:) = [1-s 1-s 1];
                    else
                        s = (ncm2-i)/ncm2;
                        cmap(i,:) = [1 1-s 1-s];
                    end
                end
            end
            mn = min(im(:));
            mx = max(im(:));
            set(gca, 'CLimMode', 'Manual');
            if mn < 0 && mx > 0
                a = max(-mn, mx);
                set(gca, 'CLim', [-a a]);
            elseif mn > 0
                set(gca, 'CLim', [-mx mx]);
            elseif mx < 0
                set(gca, 'CLim', [-mn mn]);
            end
            colormap(cmap);
        end

        if opt.axes
            xlabel('u (pixels)');
            ylabel('v (pixels)');
        else
            set(gca, 'Xtick', [], 'Ytick', []);
        end
        if opt.square
            set(gca, 'DataAspectRatio', [1 1 1]);
        end
        figure(gcf);    % bring to top
        set(hi, 'CDataMapping', 'scaled');
                
        if opt.print
            print(opt.print, '-depsc');
            return
        end
        if opt.gui
            htf = uicontrol(gcf, ...
                    'style', 'text', ...
                    'units',  'norm', ...
                    'pos', [.5 .93 .5 .07], ...
                    'HorizontalAlignment', 'left', ...
                    'string', '' ...
                );
            ud = [gca htf hi axis];
            set(gca, 'UserData', ud);
            set(hi, 'UserData', ud);

            % create pushbuttons
            uicontrol(gcf,'style','push', ...
                'string','line', ...
                'foregroundcolor', [0 0 1], ...
                'units','norm','pos',[0 .93 .1 .07], ...
                'userdata', ud, ...
                'callback', 'idisp(''line'')');
            uicontrol(gcf,'style','push', ...
                'string','histo', ...
                'foregroundcolor', [0 0 1], ...
                'units','norm','pos',[0.1 .93 .1 .07], ...
                'userdata', ud, ...
                'callback', 'idisp(''histo'')');
            uicontrol(gcf,'style','push', ...
                'string','zoom', ...
                'foregroundcolor', [0 0 1], ...
                'units','norm','pos',[.2 .93 .1 .07], ...
                'userdata', ud, ...
                'callback', 'idisp(''zoom'')');
            uicontrol(gcf,'style','push', ...
                'string','unzoom', ...
                'foregroundcolor', [0 0 1], ...
                'units','norm','pos',[.3 .93 .15 .07], ...
                'userdata', ud, ...
                'DeleteFcn', 'idisp(''cleanup'')', ...
                'callback', 'idisp(''unzoom'')');
            set(gcf, 'Color', [0.8 0.8 0.9]);
            htf = uicontrol(gcf, ...
                    'style', 'text', ...
                    'units',  'norm', ...
                    'pos', [.6 0 .4 .04], ...
                    'ForegroundColor', [0 0 1], ...
                    'BackgroundColor', get(gcf, 'Color'), ...
                    'HorizontalAlignment', 'right', ...
                    'string', 'Machine Vision Toolbox for Matlab  ' ...
                );

            set(hi, 'UserData', ud);
            set(gcf, 'WindowButtonDownFcn', 'idisp(''down'')');
            set(gcf, 'WindowButtonUpFcn', 'idisp(''up'')');
        end
		return;
	end

% otherwise idisp() is being invoked on a GUI event

	if nargin == 0,
		% mouse push or motion request
		h = get(gcf, 'CurrentObject'); % image
		ud = get(h, 'UserData');		% axis
		h_ax = ud(1);	% axes
		tf = ud(2);	% string field
		hi = ud(3);	% the image
		cp = get(h_ax, 'CurrentPoint');
		x = round(cp(1,1));
		y = round(cp(1,2));
		imdata = get(hi, 'CData');
		set(tf, 'String', ['(' num2str(x) ', ' num2str(y) ') = ' num2str(imdata(y,x,:), 4)]);
		drawnow
	elseif nargin == 1,
		switch im,
        case 'cleanup'
            %fprintf('cleaning up handlers\n');
            set(gcf, 'WindowButtonDownFcn', '');
            set(gcf, 'WindowButtonUpFcn', '');

		case 'down',
			% install pixel value inspector
			set(gcf, 'WindowButtonMotionFcn', 'idisp');
			idisp
			
		case 'up',
			set(gcf, 'WindowButtonMotionFcn', '');

		case 'line',
			h = get(gcf, 'CurrentObject'); % push button
			ud = get(h, 'UserData');
			ax = ud(1);	% axes
			tf = ud(2);	% string field
			hi = ud(3);	% the image
			set(tf, 'String', 'Click first point');
			[x1,y1] = ginput(1);
			x1 = round(x1); y1 = round(y1);
			set(tf, 'String', 'Click last point');
			[x2,y2] = ginput(1);
			x2 = round(x2); y2 = round(y2);
			set(tf, 'String', '');
			imdata = get(hi, 'CData');
			dx = x2-x1; dy = y2-y1;
			if abs(dx) > abs(dy),
				x = x1:x2;
				y = round(dy/dx * (x-x1) + y1);
				figure

                if size(imdata,3) > 1
                    set(gca, 'ColorOrder', eye(3,3), 'Nextplot', 'replacechildren');
                    n = size(imdata,1)*size(imdata,2);
                    z = [];
                    for i=1:size(imdata,3)
                        z = [z imdata(y+x*numrows(imdata)+(i-1)*n)'];
                    end
                    plot(x', z);
                else
                    plot(imdata(y+x*numrows(imdata)))
                end
			else
				y = y1:y2;
                x = round(dx/dy * (y-y1) + x1);
				figure
                if size(imdata,3) > 1
                    set(gca, 'ColorOrder', eye(3,3), 'Nextplot', 'replacechildren');
                    n = size(imdata,1)*size(imdata,2);
                    z = [];
                    for i=1:size(imdata,3)
                        z = [z imdata(y+x*numrows(imdata)+(i-1)*n)'];
                    end
                    plot(z, y');
                else
                    plot(imdata(y+x*numrows(imdata)))
                end

            end
            title(sprintf('(%d,%d) to (%d,%d)', x1, y1, x2, y2));
            xlabel('distance (pixels)')
            ylabel('greyscale');
            grid on
            
        case 'histo',
            h = get(gcf, 'CurrentObject'); % push button
			ud = get(h, 'UserData');
			ax = ud(1);	% axes
			hi = ud(3);	% the image;
			imdata = get(hi, 'CData');
            b = floor(axis);   % bounds of displayed image
            if b(1) == 0,
                b = [1 b(2) 1 b(4)];
            end
            ud
            size(imdata)
            b
            figure
            imdata = double(imdata(b(3):b(4), b(1):b(2),:));
            ihist(imdata);

		case 'zoom',
            % get the rubber band box
            waitforbuttonpress
            cp0 = floor( get(gca, 'CurrentPoint') );

            rect = rbbox;	    % return on up click

            cp1 = floor( get(gca, 'CurrentPoint') );

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

            % extract the view region
			axes(gca);
			axis([left right top bot]);
		case 'unzoom',
			h = get(gcf, 'CurrentObject'); % push button
			ud = get(h, 'UserData');
			h_ax = ud(1);	% axes
			axes(h_ax);
			axis(ud(4:7));

        otherwise
            idisp( imread(z) );
		end
	end
