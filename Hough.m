%IHOUGH	Hough transform
%
%	params = IHOUGH
%	H = IHOUGH(IM)
%	H = IHOUGH(IM, params)
%
%	Compute the Hough transform of the image IM data.
%
%	The appropriate Hough accumulator cell is incremented by the
%	absolute value of the pixel value if it exceeds 
%	params.edgeThresh times the maximum value found.
%
%	Pixels within params.border of the edge will not increment.
%
% 	The accumulator array has theta across the columns and offset down 
%	the rows.  Theta spans the range -pi/2 to pi/2 in params.Nth increments.
%	Offset is in the range 1 to number of rows of IM with params.Nd steps.
%
%	Clipping is applied so that only those points lying within the Hough 
%	accumulator bounds are updated.
%
%	The output argument H is a structure that contains the accumulator
%	and the theta and offset value vectors for the accumulator columns 
%	and rows respectively.  With no output 
%	arguments the Hough accumulator is displayed as a greyscale image.
%
%	H.h	the Hough accumulator
%	H.theta	vector of theta values corresponding to H.h columns
%	H.d	vector of offset values corresponding to H.h rows
% 
%	For this version of the Hough transform lines are described by
%
%		d = y cos(theta) + x sin(theta)
%
%	where theta is the angle the line makes to horizontal axis, and d is 
%	the perpendicular distance between (0,0) and the line.  A horizontal 
%	line has theta = 0, a vertical line has theta = pi/2 or -pi/2
%
%	The parameter structure:
%
%	params.Nd number of offset steps (default 64)
%	params.Nth number of theta steps (default 64)
%	params.edgeThresh increment threshold (default 0.1)
%	params.border width of non-incrmenting border(default 8)
%
%
% SEE ALSO: xyhough testpattern isobel ilap

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

classdef Hough < handle

    properties
        Nrho
        Ntheta
        border
        radius
        edgeThresh
        interpWidth
        houghThresh

        A       % the Hough accumulator
        rho       % the rho values for the centre of each bin vertically
        theta   % the theta values for the centre of each bin horizontally
        rho_offset
        rho_scale
    end

    methods
        function h = Hough(IM, varargin)

            h.Nrho = 401;
            h.Ntheta = 400;
            h.edgeThresh = 0.1;
            h.interpWidth = 3;
            h.houghThresh = 0.5;
            h.radius = [];
            if nargin > 0,
                count = 1;
                while count <= length(varargin)
                    switch lower(varargin{count})
                    case 'nbins'
                        nbins = varargin{count+1}; count = count+1;
                        if length(nbins) == 1
                            h.Ntheta = nbins;
                            h.Nrho = nbins;
                         elseif length(nbins) == 2
                            h.Ntheta = nbins(1);
                            h.Nrho = nbins(2);
                        else
                            error('1 or 2 elements for nbins');
                        end
                        
                    case 'distance'
                        h.radius = varargin{count+1}; count = count+1;
                    case 'interpwidth'
                        h.interpWidth = 2*varargin{count+1}+1; count = count+1;
                    case 'houghthresh'
                        h.houghThresh = varargin{count+1}; count = count+1;
                    case 'edgethresh'
                        h.edgeThresh = varargin{count+1}; count = count+1;
                    otherwise
                        error( sprintf('unknown option <%s>', varargin{count}));
                    end
                    count = count + 1;
                end
            end


            h.Nrho = bitor(h.Nrho, 1);            % Nrho must be odd
            h.Ntheta = floor(h.Ntheta/2)*2; % Ntheta must even
            
            if isempty(h.radius)
                h.radius = (h.interpWidth-1)/2;
            end
            [nr,nc] = size(IM);

            % find the significant edge pixels
            IM = abs(IM);
            globalMax = max(IM(:));
            i = find(IM > (globalMax*h.edgeThresh));	
            [r,c] = ind2sub(size(IM), i);

            xyz = [c r IM(i)];

            % now pass the x/y/strenth info to xyhough
            h.A = h.xyhough(xyz, norm2(nr,nc));
        end

        function display(h)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(h))
            if loose
                disp(' ');
            end
        end

        function s = char(h)
            s = sprintf('Hough: nd=%d, ntheta=%d, interp=%dx%d, distance=%d', ...
                h.Nrho, h.Ntheta, h.interpWidth, h.interpWidth, h.radius);
        end
        
        function show(h)
            clf
            hi = image(h.theta, h.rho, h.A/max(max(h.A)));
            set(hi, 'CDataMapping', 'scaled');
            set(gca, 'YDir', 'normal');
            set(gca, 'Xcolor', [1 1 1]*0.5);
            set(gca, 'Ycolor', [1 1 1]*0.5);
            grid on
            xlabel('\theta (rad)');
            ylabel('d (pixels)');
            colormap(hot)
        end
            
        %HOUGHOVERLAY	Overlay lines on image.
        %
        %	houghoverlay(p)
        %	houghoverlay(p, ls)
        %	handles = houghoverlay(p, ls)
        %
        %	Overlay lines, one per row of p, onto the current figure.  The row
        %	is interpretted as offset and theta, the Hough transform line
        %	representation.
        %
        %	The optional argument, ls, gives the line style in normal Matlab
        %	format.
        function handles = plot(h, N, varargin)

            holdon = ishold;
            hold on

            % figure the x-axis scaling
            scale = axis;
            x = [scale(1):scale(2)]';
            y = [scale(3):scale(4)]';

            lines = h.lines();
    
            if (nargin > 1) && ~isscalar(N)
                lines = lines(1:N);
            end

            % plot it
            lines.plot(varargin{:});

        end
        
        
        %HOUGHPEAKS   Find Hough accumulator peaks.
        %
        %	p = houghpeaks(H, N, hp)
        %
        %  Returns the coordinates of N peaks from the Hough
        %  accumulator.  The highest peak is found, refined to subpixel precision,
        %  then hp.radius radius around that point is zeroed so as to eliminate
        %  multiple close minima.  The process is repeated for all N peaks.
        %  p is an n x 3 matrix where each row is the offset, theta and
        %  relative peak strength (range 0 to 1).
        %
        %  The peak detection loop breaks early if the remaining peak has a relative 
        %  strength less than hp.houghThresh.
        %  The peak is refined by a weighted mean over a w x w region around
        %  the peak where w = hp.interpWidth.
        %
        % Parameters affecting operation are:
        %
        %	hp.houghThresh	threshold on relative peak strength (default 0.4)
        %	hp.radius       radius of accumulator cells cleared around peak 
        %                                 (default 5)
        %	hp.interpWidth  width of region used for peak interpolation
        %                                 (default 5)
        %
        function out = lines(h, N)
            if nargin < 2
                N = Inf;
            end

            if N < 1
                thresh = N;
                N = Inf;
            end

            [x,y] = meshgrid(1:h.Ntheta, 1:h.Nrho);

            nw2= floor((h.interpWidth-1)/2);
            nr2= floor((h.radius-1)/2);

            [Wx,Wy] = meshgrid(-nw2:nw2,-nw2:nw2);
            globalMax = max(h.A(:));
            
            A = h.A;

            for i=1:N
                % find the current peak
                [mx,where] = max(A(:));
                %[mx where]
                
                % is the remaining peak good enough?
                if mx < (globalMax*h.houghThresh)
                    break;
                end
                [rp,cp] = ind2sub(size(A), where);
                %fprintf('\npeak height %f at (%d,%d)\n', mx, cp, rp);
                if h.interpWidth == 0
                    d = H.rho(rp);
                    theta = H.theta(cp);
                    p(i,:) = [d theta mx/globalMax];
                else
                    % refine the peak to subelement accuracy

                    k = Hough.nhood2ind(A, ones(h.interpWidth,h.interpWidth), [cp,rp]);
                    Wh = A(k);
                    %Wh                    
                    rr = Wy .* Wh;
                    cc = Wx .* Wh;
                    ri = sum(rr(:)) / sum(Wh(:)) + rp;
                    ci = sum(cc(:)) / sum(Wh(:)) + cp;
              
                    
                    %fprintf('refined %f %f\n', ci, ri);

                    % interpolate the line parameter values
                    d = interp1(h.rho, ri);
                    theta = interp1(h.theta, ci, 'linear', 0);
                    %p(i,:) = [d theta mx/globalMax];
                    L(i) = LineFeature(d, theta, mx/globalMax);
                    %p(i,:)

                end
                
                % remove the region around the peak
                k = Hough.nhood2ind(A, ones(2*h.radius+1,2*h.radius+1), [cp,rp]);
                A(k) = 0;

            end
            if nargout == 1
                out = L;
            else
                h.show
                hold on
                plot([L.theta]', [L.rho]', 'go');
                hold off
            end
        end % peaks


        %XYHOUGH	XY Hough transform
        %
        %	H = XYHOUGH(XYZ, drange, Nth)
        %
        %	Compute the Hough transform of the XY data given as the first two 
        %	columns of XYZ.  The last column, if given, is the point strength, 
        %	and is used as the increment for the Hough accumulator for that point.
        %
        % 	The accumulator array has theta across the columns and offset down 
        %	the rows.  Theta spans the range -pi/2 to pi/2 in Nth increments.
        %	The distance span is given by drange which is either
        %		[dmin dmax] in the range dmin to dmax in steps of 1, or
        %		[dmin dmax Nd] in the range dmin to dmax with Nd steps.
        %
        %	Clipping is applied so that only those points lying within the Hough 
        %	accumulator bounds are updated.
        %
        %	The output arguments TH and D give the theta and offset value vectors 
        %	for the accumulator columns and rows respectively.  With no output 
        %	arguments the Hough accumulator is displayed as a greyscale image.
        % 
        %	For this version of the Hough transform lines are described by
        %
        %		d = y cos(theta) + x sin(theta)
        %
        %	where theta is the angle the line makes to horizontal axis, and d is 
        %	the perpendicular distance between (0,0) and the line.  A horizontal 
        %	line has theta = 0, a vertical line has theta = pi/2 or -pi/2
        %
        % SEE ALSO: ihough mkline, mksq, isobel
        %
        function H = xyhough(h, XYZ, dmax, Nth)

            inc = 1;
            
            h.rho_offset = (h.Nrho+1)/2;
            h.rho_scale = (h.Nrho-1)/2 / dmax;
            
            if numcols(XYZ) == 2
                XYZ = [XYZ ones(numrows(XYZ),1)];
            end

            % compute the quantized theta values and the sin/cos
            nt2 = h.Ntheta/2;
            h.theta = [-nt2:(nt2-1)]'/nt2*pi/2;
            st = sin(h.theta);
            ct = cos(h.theta);

            H = zeros(h.Nrho, h.Ntheta);		% create the Hough accumulator

            % this is a fast `vectorized' algorithm

            % evaluate the index of the top of each column in the Hough array
            col0 = ([1:h.Ntheta]'-1)*h.Nrho;
            %col0_r = [(Nth-1):-1:0]'*Nrho + 1;

            for xyz = XYZ'
                x = xyz(1);		% determine (x, y) coordinate
                y = xyz(2);
                inc = xyz(3);
                inc =1 ;
                
                rho = y * ct + x * st;
                
                di = round( rho*h.rho_scale + h.rho_offset);	% in the range 1 .. Nrho
                % which elements are within the column
                %d(d<0) = -d(d<0);
                %inrange = d<Nrho;

                di = di + col0;   	% convert array of d values to Hough indices
                H(di) = H(di) + inc;	% increment the accumulator cells
            end

            nd2 = (h.Nrho-1)/2;
            h.rho = [-nd2:nd2]'/h.rho_scale;
        end % xyhough
    

    end % methods
    
    methods(Static)
        function idx = nhood2ind(im, SE, centre)
            [y,x] = find(SE);

            sw = (numcols(SE)-1)/2;
            sh = (numrows(SE)-1)/2;
            x = x + centre(1)-sw-1;
            y = y + centre(2)-sh-1;

            w = numcols(im);
            h = numrows(im);

            y(x<1) = h - y(x<1);
            x(x<1) = x(x<1) + w;
            
            y(x>w) = h - y(x>w);
            x(x>w) = x(x>w) - w;
            


            idx = sub2ind(size(im), y, x);
            idx = reshape(idx, size(SE));
        end
    end % static methods
end % Hough
