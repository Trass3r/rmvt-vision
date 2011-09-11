%IDISP	Interactive image display tool
%
% IDISP(IM, OPTIONS) displays an image and allows interactive investigation
% of pixel value, linear profile, histogram and zooming.  The image is
% displayed in a figure with a toolbar across the top.  If IM is a cell
% array of images, they are first concatenated (horizontally).
%
% User interface:
%
% - Left clicking on a pixel will display its value in a box at the top.
%
% - The "line" button allows two points to be specified and a new figure
%   displays intensity along a line between those points.
%
% - The "histo" button displays a histogram of the pixel values in a new figure.
%   If the image is zoomed, the histogram is computed over only those pixels in 
%   view.
%
% -  The "zoom" button requires a left-click and drag to specify a box which
%    defines the zoomed view.
%
% Options::
% 'ncolors',N    number of colors in the color map (default 256)
% 'nogui'        display the image without the GUI
% 'noaxes'       no axes on the image
% 'noframe'      no axes or frame on the image
% 'plain'        no axes, frame or GUI
% 'bar'          add a color bar to the image
% 'print',F      write the image to file F in EPS format
% 'square'       display aspect ratio so that pixels are squate
% 'wide'         make figure very wide, useful for displaying stereo pair
% 'flatten'      display image planes (colors or sequence) as horizontally 
%                adjacent images
% 'ynormal'      y-axis increases upward, image is inverted
% 'cscale',C     C is a 2-vector that specifies the grey value range that spans
%                the colormap.
% 'xydata',XY    XY is a cell array whose elements are vectors that span the 
%                x- and y-axes respectively.
% 'colormap',C   Set colormap C (Nx3)
% 'grey'         color map: greyscale unsigned, zero is black, maximum value 
%                is white
% 'invert'       color map: greyscale unsigned, zero is white, maximum value 
%                is black
% 'signed'       color map: greyscale signed, positive is blue, negative is red,
%                zero is black
% 'invsigned'    color map: greyscale signed, positive is blue, negative is red,
%                zero is white
% 'random'       color map: random values, highlights fine structure
% 'dark'         color map: greyscale unsigned, darker than 'grey', good for 
%                superimposed graphics
%
% Notes::
% - Color images are displayed in true color mode: pixel triples map to display
%   pixels
% - Grey scale images are displayed in indexed mode: the image pixel value is 
%   mapped through the color map to determine the display pixel value.
% - The minimum and maximum image values are mapped to the first and last 
%   element of the color map, which by default ('greyscale') is the range black
%   to white.
%
% See also IMAGE, CAXIS, COLORMAP, ICONCAT.



% Copyright (C) 1993-2011, by Peter I. Corke
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

    opt.ncolors = 256;
    opt.gui = true;
    opt.axes = true;
    opt.square = false;
    opt.wide = false;
    opt.colormap = [];
    opt.print = [];
    opt.bar = false;
    opt.frame = true;
    opt.ynormal = false;
    opt.cscale = [];
    opt.xydata = [];
    opt.plain = false;
    opt.flatten = false;
    opt.toolbar = false;
    opt.colormap_std = {[], 'grey', 'signed', 'invsigned', 'random', 'invert', 'dark'};

    [opt,arglist] = tb_optparse(opt, varargin);

    if opt.plain
        opt.frame = false;
        opt.gui = false;
    end
    if ~isempty(opt.print)
        opt.gui = false;
    end
    if opt.flatten
        im = reshape( im, size(im,1), size(im,2)*size(im,3) );
    end

    if length(arglist) ~= 0
        warning(['Unknown options: ', arglist]);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % command line invocation, display the image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % display the image
    clf
    ud = [];
    
    if iscell(im)
        % image is a cell array
        [im,ud.u0] = iconcat(im);
    end

    ud.size = size(im);
    
    set(gca, 'CLimMode', 'Manual');
    i_min = min(im(:));
    i_max = max(im(:));

    if i_min == i_max
        if isfloat(im)
            i_min = 0;
            i_max = 1;
        else
            i_min = 0;
            i_max = intmax(class(im));
        end
    end
    set(gca, 'CLim', [i_min, i_max]);
    
    if ~isempty(opt.xydata)
        hi = image(opt.xydata{1}, opt.xydata{2}, im);
    else
        hi = image(im, 'CDataMapping', 'scaled');
    end

    if opt.wide
        set(gcf, 'units', 'norm');
        pos = get(gcf, 'pos');
        set(gcf, 'pos', [0.0 pos(2) 1.0 pos(4)]);
    end


    if isempty(opt.colormap_std)
        if isempty(opt.colormap)
            % default colormap
            %disp('default color map');
            cmap = gray(opt.ncolors);
        else
            % load a Matlab color map
            disp('matlab color map');
            cmap = feval(opt.colormap);
        end
    else
        % a builtin shorthand color map was specified
        %disp(['builtin color map: ', opt.colormap_std]);
        switch opt.colormap_std
        case 'random'
            cmap = rand(opt.ncolors,3);
        case 'dark'
            cmap = gray(opt.ncolors)*0.5;
        case 'grey'
            cmap = gray(opt.ncolors);
        case 'invert'
                % invert the monochrome color map: black <-> white
            cmap = gray(opt.ncolors);
            cmap = cmap(end:-1:1,:);
        case {'signed', 'invsigned'}
                % signed color map, red is negative, blue is positive, zero is black
                % inverse signed color map, red is negative, blue is positive, zero is white
            cmap = zeros(opt.ncolors, 3);
            opt.ncolors = bitor(opt.ncolors, 1);    % ensure it's odd
            ncm2 = ceil(opt.ncolors/2);
            if strcmp(opt.colormap, 'signed')
                % signed color map, red is negative, blue is positive, zero is black
                for i=1:opt.ncolors
                    if i > ncm2
                        cmap(i,:) = [0 0 1] * (i-ncm2) / ncm2;
                    else
                        cmap(i,:) = [1 0 0] * (ncm2-i) / ncm2;
                    end
                end
            else
                % inverse signed color map, red is negative, blue is positive, zero is white
                for i=1:opt.ncolors
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
        end
    end
    colormap(cmap);

    if opt.bar
        colorbar
    end
    if opt.frame
        if opt.axes
            xlabel('u (pixels)');
            ylabel('v (pixels)');
        else
            set(gca, 'Xtick', [], 'Ytick', []);
        end
    else
        set(gca, 'Visible', 'off');
    end
    if opt.square
        set(gca, 'DataAspectRatio', [1 1 1]);
    end
    if opt.ynormal
        set(gca, 'YDir', 'normal');
    end
    set(hi, 'CDataMapping', 'scaled');
    if ~isempty(opt.cscale)
        set(gca, 'Clim', opt.cscale);
    end
    
    figure(gcf);    % bring to top

    if opt.print
        print(opt.print, '-depsc');
        return
    end
    if opt.gui
        if ~opt.toolbar
            set(gcf, 'MenuBar', 'none');
            set(gcf, 'ToolBar', 'none');
        end
        htf = uicontrol(gcf, ...
                'style', 'text', ...
                'units',  'norm', ...
                'pos', [.5 .935 .48 .05], ...
                'background', [1 1 1], ...
                'HorizontalAlignment', 'left', ...
                'string', ' Machine Vision Toolbox for Matlab  ' ...
            );
        ud.axis = gca;
        ud.panel = htf;
        ud.image = hi;
        set(gca, 'UserData', ud);
        set(hi, 'UserData', ud);

        % show the variable name in the figure's title bar
        varname = inputname(1);
        if isempty(varname)
            set(gcf, 'name', 'idisp');
        else
            set(gcf, 'name', sprintf('idisp: %s', varname));
        end

        % create pushbuttons
        uicontrol(gcf,'Style','Push', ...
            'String','line', ...
            'Foregroundcolor', [0 0 1], ...
            'Units','norm','pos',[0 .93 .1 .07], ...
            'UserData', ud, ...
            'Callback', @(src,event) idisp_callback('line', src) );
        uicontrol(gcf,'Style','Push', ...
            'String','histo', ...
            'Foregroundcolor', [0 0 1], ...
            'Units','norm','pos',[0.1 .93 .1 .07], ...
            'UserData', ud, ...
            'Callback', @(src,event) idisp_callback('histo', src) );
        uicontrol(gcf,'Style','Push', ...
            'String','zoom', ...
            'Foregroundcolor', [0 0 1], ...
            'Units','norm','pos',[.2 .93 .1 .07], ...
            'Userdata', ud, ...
            'Callback', @(src,event) idisp_callback('zoom', src) );
        uicontrol(gcf,'Style','Push', ...
            'String','unzoom', ...
            'Foregroundcolor', [0 0 1], ...
            'Units','norm','pos',[.3 .93 .15 .07], ...
            'Userdata', ud, ...
            'Callback', @(src,event) idisp_callback('unzoom', src) );
            %'DeleteFcn', 'idisp(''cleanup'')', ...
        set(gcf, 'Color', [0.8 0.8 0.9], ...
            'WindowButtonDownFcn', @(src,event) idisp_callback('down', src), ...
            'WindowButtonUpFcn', @(src,event) idisp_callback('up', src) );
%            htf = uicontrol(gcf, ...
%                    'style', 'text', ...
%                    'units',  'norm', ...
%                    'pos', [.6 0 .4 .04], ...
%                    'ForegroundColor', [0 0 1], ...
%                    'BackgroundColor', get(gcf, 'Color'), ...
%                    'HorizontalAlignment', 'right', ...
%                    'string', 'Machine Vision Toolbox for Matlab  ' ...
%                );

        set(hi, 'UserData', ud);
    end
    set(hi, 'DeleteFcn', @(src,event) idisp_callback('idelete', src) );
    set(gca, ...
        'DeleteFcn', @(src,event) idisp_callback('destroy', src), ...
        'NextPlot', 'replace', ...
        'UserData', ud);

end

% invoked on a GUI event
function idisp_callback(cmd, src)

%disp(['in callback: ', cmd]);
	if isempty(cmd)
		% mouse push or motion request
		h = get(gcf, 'CurrentObject'); % image
		ud = get(h, 'UserData');		% axis
        
        if ~isempty(ud)
            cp = get(ud.axis, 'CurrentPoint');
            x = round(cp(1,1));
            y = round(cp(1,2));
            try
                imdata = get(ud.image, 'CData');
                set(ud.panel, 'String', sprintf(' (%d, %d) = %s', x, y, num2str(imdata(y,x,:), 4)));
                drawnow
            end
        end
	else
		switch cmd
        case {'destroy', 'idelete'}
            %fprintf('cleaning up figure\n');
            clf
            set(gcf, 'MenuBar', 'figure');
            set(gcf, 'ToolBar', 'figure');
            set(gcf, 'WindowButtonUpFcn', '');
            set(gcf, 'WindowButtonDownFcn', '');
        case 'cleanup'
            %fprintf('cleaning up handlers\n');
            set(gcf, 'WindowButtonDownFcn', '');
            set(gcf, 'WindowButtonUpFcn', '');

		case 'down',
			% install pixel value inspector
			set(gcf, 'WindowButtonMotionFcn', @(src,event) idisp_callback([], src) );
			idisp_callback([], src);
			
		case 'up',
			set(gcf, 'WindowButtonMotionFcn', '');

		case 'line',
			h = get(gcf, 'CurrentObject'); % push button
                        
			ud = get(h, 'UserData');
            
			set(ud.panel, 'String', 'Click first point');
			[x1,y1] = ginput(1);
			x1 = round(x1); y1 = round(y1);
			set(ud.panel, 'String', 'Click last point');
			[x2,y2] = ginput(1);
			x2 = round(x2); y2 = round(y2);
			set(ud.panel, 'String', '');
			imdata = get(ud.image, 'CData');
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

			imdata = get(ud.image, 'CData');
            b = floor(axis);   % bounds of displayed image
            if b(1) == 0,
                b = [1 b(2) 1 b(4)];
            end

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
			axes(ud.axis);
			axis([1 ud.size(2) 1 ud.size(1)]);

        otherwise
            idisp( imread(z) );
		end
	end
end
