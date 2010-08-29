%LineFeature
%
classdef LineFeature < handle

    properties
        rho
        theta
        strength
        length
    end

    methods
        function h = LineFeature(rho, theta, strength, length)
            if isa(rho, 'LineFeature')
                % clone the passed object
                obj = rho;
                h.rho = obj.rho;
                h.theta = obj.theta;
                h.strength = obj.strength;
                h.length = obj.length;
                return
            end
            if nargin > 0
                h.rho = rho;
                h.theta = theta;
                h.strength = strength;
                if nargin > 3
                    h.length = length;
                end
            end
        end

        function val = rho_v(lines)
            val = [lines.rho];
        end

        function val = theta_v(lines)
            val = [lines.theta];
        end

        function val = strength_v(lines)
            val = [lines.strength];
        end

        function val = length_v(lines)
            val = [lines.length];
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

        function ss = char(lines)
            ss = [];
            for line=lines
                s = sprintf('rho=%g, theta=%g, strength=%g', ...
                    line.rho, line.theta, line.strength);
                if ~isempty(line.length)
                    s = strcat(s, sprintf(', length=%f', line.length));
                end
                ss = strvcat(ss, s);
            end
        end
                %fprintf(' intercept     theta   strength\n');
                %disp(p);
        
        function handles = plot(lines, varargin)

            holdon = ishold;
            hold on

            % figure the x-axis scaling
            scale = axis;
            x = [scale(1):scale(2)]';
            y = [scale(3):scale(4)]';
            hl = [];

            % plot it
            for line=lines

                %fprintf('theta = %f, d = %f\n', line.theta, line.rho);
                if abs(cos(line.theta)) > 0.5,
                    % horizontalish lines
                    %disp('hoz');
                    h = plot(x, -x*tan(line.theta) + line.rho/cos(line.theta), varargin{:});
                else
                    % verticalish lines
                    %disp('vert');
                    h = plot( -y/tan(line.theta) + line.rho/sin(line.theta), y, varargin{:});
                end
                hl = [hl h];
            end

            if ~holdon,
                hold off
            end

            if nargout > 0,
                handles = hl;
            end
            figure(gcf);        % bring it to the top
        end

        function out = seglength(lines, im_edge, gap)

            if nargin < 3
                gap = 5;
            end

            out = [];
            for L=lines
                %fprintf('d=%f, theta=%f; ', L.rho, L.theta)


                if abs(L.theta) < pi/4
                    xmin = 1; xmax = numcols(im_edge);
                    m = -tan(L.theta); c = L.rho/cos(L.theta);
                    ymin = round(xmin*m + c);
                    ymax = round(xmax*m + c);
                else
                    ymin = 1; ymax = numrows(im_edge);
                    m = -1/tan(L.theta); c = L.rho/sin(L.theta);
                    xmin = round(ymin*m + c);
                    xmax = round(ymax*m + c);
                end


                line = bresenham(xmin, ymin, xmax, ymax);

                line = line(line(:,2)>=1,:);
                line = line(line(:,2)<=numrows(im_edge),:);
                line = line(line(:,1)>=1,:);
                line = line(line(:,1)<=numcols(im_edge),:);

                contig = 0;
                contig_max = 0;
                total = 0;
                missing = 0;
                for pp=line'
                    pix = im_edge(pp(2), pp(1));
                    if pix == 0
                        missing = missing+1;
                        if missing > gap
                            contig_max = max(contig_max, contig);
                            contig = 0;
                        end
                    else
                        contig = contig+1;
                        total = total+1;
                        missing = 0;
                    end
                    %ee(pp(2), pp(1))=1;
                end
                contig_max = max(contig_max, contig);

                %fprintf('  strength=%f, len=%f, total=%f\n', L.strength, contig_max, total);
                o = LineFeature(L);     % clone the object
                o.length = contig_max;
                out = [out o];
            end
        end
        
    end % methods
end % Hough
