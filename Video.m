%Video Class to read video stream from an attached camera.
%
%
% SEE ALSO: Movie
%
% Platform-indepent camera interface based on motmot by Andrew Straw

% mmread brings the whole movie into memory.  Not entirely sure what
% libavbin uses memory-wise, it takes a long time to "open" the file.

classdef Movie < handle

    properties
        width
        height
        rate

        curFrame
    end

    methods

        function m = Movie(filename)

            m.curFrame = 0;
        end

        % destructor
        function delete(m)
        end

        function close(m)
        end

        function [im, time] = grab(m, opt)
            [data, time] = FFGrab('getVideoFrame', 0, m.curFrame);
            m.curFrame = m.curFrame + 1;

            if (numel(data) > 3*width*height)
                warning('Movie: dimensions do not match data size. Got %d bytes for %d x %d', numel(data), width, height);
            end

            if any(size(data) == 0)
                warning('Movie: could not decode frame %d', m.curFrame);
            else
                % the data ordering is wrong for matlab images, so permute it
                data = permute(reshape(data, 3, m.width, m.height),[3 2 1]);
                im = data;
            end
        end

        function s = char(m)
            s = '';
            s = strvcat(s, sprintf('%d video streams', m.nrVideoStreams));
            s = strvcat(s, sprintf('  %d x %d @ %d fps', m.width, m.height, m.rate));
            s = strvcat(s, sprintf('  %d frames, %f sec', m.nrFramesTotal, m.totalDuration));
            s = strvcat(s, sprintf('%d audio streams', m.nrAudioStreams));
        end

        function display(m)
            loose = strcmp( get(0, 'FormatSpacing'), 'loose');
            if loose
                disp(' ');
            end
            disp([inputname(1), ' = '])
            if loose
                disp(' ');
            end
            disp(char(m))
            if loose
                disp(' ');
            end
        end
    end
end

