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

class Hough < handle

    properties
        Nd
        Ntheta
        border
        radius
        edgeThresh

        H       % the Hough accumulator
        d       % the d values
        theta   % the theta values
    end

    methods
        function h = Hough(IM, varargin)

            if nargin == 0,
                h.Nd = 64;
                h.Ntheta = 64;
                h.edgeThresh = 0.1;
            else
                count = 1;
                while count <= length(varargin)
                    switch lower(varargin{count})
                    case 'nd'
                        h.Nd = varargin{count+1}; count = count+1;
                    case 'ntheta'
                        h.Ntheta = varargin{count+1}; count = count+1;
                    case 'dims'
                        v = varargin{count+1}; count = count+1;
                        h.Nd = v(1);
                        h.Ntheta = v(2);
                    case 'radius'
                        h.radius = varargin{count+1}; count = count+1;
                    case 'edgethresh'
                        h.edgeThresh = varargin{count+1}; count = count+1;
                    otherwise
                        error( sprintf('unknown option <%s>', varargin{count}));
                    end
                    count = count + 1;
                end
            end

            [nr,nc] = size(IM);

            % find the significant edge pixels
            IM = abs(IM);
            globalMax = max(IM(:));
            i = find(IM > (globalMax*params.edgeThresh));	
            [r,c]=ind2sub(size(IM), i);

            xyz = [c r IM(i)];

            % now pass the x/y/strenth info to xyhough
            [h.H,h.d,h.theta] = h.hough_xy(xyz, [1 nr params.Nd], params.Nth);
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
            s = sprintf('Hough: nd=%d, ntheta=%d', h.Nd, h.Ntheta);
        end

        function show(h)
            image(h.th, h.dd, 64*h.H/max(max(h.H)));
            xlabel('theta (rad)');
            ylabel('intercept');
            colormap(gray(64))
        end
            
        function plot(h, varargin)
            holdon = ishold
            hold on
            if ~holdon
                hold off
            end
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

            % p = [d theta]
            p = h.peaks(N);

            % plot it
            for i=1:numrows(p),
                d = p(i,1);
                theta = p(i,2);

                %fprintf('theta = %f, d = %f\n', theta, d);
                if abs(cos(theta)) > 0.5,
                    % horizontalish lines
                    hl(i) = plot(x, -x*tan(theta) + d/cos(theta), ls);
                else
                    % verticalish lines
                    hl(i) = plot( -y/tan(theta) + d/sin(theta), y, ls);
                end
            end

            if ~holdon,
                hold off
            end

            if nargout > 0,
                handles = hl;
            end
            figure(gcf);        % bring it to the top
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
        function p = peaks(h, N)
            if nargin < 2
                N = Inf;
            end

            if N < 1
                thresh = N;
                N = Inf;
            end

            [x,y] = meshgrid(1:h.nd, 1:h.ntheta);

            nw2= floor((params.interpWidth-1)/2);
            [Wx,Wy] = meshgrid(-nw2:nw2,-nw2:nw2);
            globalMax = max(H.h(:));
            
            for i=1:N,
                % find the current peak
                [mx,where] = max(H.h(:));
                
                % is the remaining peak good enough?
                if mx < (globalMax*params.houghThresh),
                    break;
                end
                [rp,cp] = ind2sub(size(H.h), where);
                
                if params.interpWidth == 0,
                    d = H.d(rp);
                    theta = H.theta(cp);
                    p(i,:) = [d theta mx/globalMax];
                else,
                    % refine the peak to subelement accuracy
                    try,
                        Wh = H.h(rp-nw2:rp+nw2,cp-nw2:cp+nw2);
                    catch,
                        % window is at the edge, do it the slow way
                        % we wrap the coordinates around the accumulator on all edges
                        for r2=1:2*nw2+1,
                            r3 = rp+r2-nw2-1;
                            if r3 > nr,
                                r3 = r3 - nr;
                            elseif r3 < 1,
                                r3 = r3 + nr;
                            end
                            for c2=1:2*nw2+1,
                                c3 = cp+c2-nw2-1;
                                if c3 > nc,
                                    c3 = c3 - nc;
                                elseif c3 < 1,
                                    c3 = c3 + nc;
                                end
                                Wh(r2,c2) = H.h(r3,c3);
                            end
                        end

                    end
                    rr = Wy .* Wh;
                    cc = Wx .* Wh;
                    ri = sum(rr(:)) / sum(Wh(:)) + rp;
                    ci = sum(cc(:)) / sum(Wh(:)) + cp;
                    %fprintf('refined %f %f\n', r, c);

                    % interpolate the line parameter values
                    d = interp1(H.d, ri);
                    theta = interp1(H.theta, ci);
                    p(i,:) = [d theta mx/globalMax];

                end
                
                % remove the region around the peak
                k = (x(:)-cp).^2 + (y(:)-rp).^2 < params.radius^2;
                H.h(k) = 0;
            end
        end

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
        function [H,dd,th] = xyhough(h, XYZ, drange, Nth)

            dmin = drange(1);
            dmax = drange(2);
            dinc = 1;
            if length(drange) > 2,
                Nd = drange(3);
            else
                Nd = dmax - dmin + 1;
            end
            dinc = (dmax - dmin) / (Nd - 1);
            
            if numcols(XYZ) == 2,
                XYZ = [XYZ ones(numrows(XYZ),1)];
            end

            % compute the quantized theta values and the sin/cos
            th = [0:(Nth-1)]'/Nth*pi-pi/2;
            st = sin(th);
            ct = cos(th);

            H = zeros(Nd, Nth);		% create the Hough accumulator

            % this is a fast `vectorized' algorithm

            % evaluate the index of the top of each column in the Hough array
            col0 = [0:(Nth-1)]'*Nd;

            for xyz = XYZ',
                x = xyz(1);		% determine (x, y) coordinate
                y = xyz(2);
                inc = xyz(3);
                d = round( ((y * ct - x * st)-dmin)/dinc );	% in the range 0 .. Nd-1

                % which elements are within the column
                inrange = (d>=0) & (d<Nd);

                di = d + col0 + 1;	% convert array of d values to Hough indices
                di = di(inrange);	% ignore those out of column range

                H(di) = H(di) + inc;	% increment the accumulator cells
            end

            dd = [0:(Nd-1)]'*dinc+dmin;

        end
    end
end

