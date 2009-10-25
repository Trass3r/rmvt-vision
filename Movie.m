%MOVIE Class to read movie file
%
%
% SEE ALSO: Video
%
% Based on mmread by Micah Richert

% mmread brings the whole movie into memory.  Not entirely sure what
% libavbin uses memory-wise, it takes a long time to "open" the file.

% Copyright 2008 Micah Richert
% 
% This file is part of mmread.
% 
% mmread is free software; you can redistribute it and/or modify it
% under the terms of the GNU Lesser General Public License as
% published by the Free Software Foundation; either version 3 of
% the License, or (at your option) any later version.
% 
% mmread is distributed WITHOUT ANY WARRANTY.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public
% License along with mmread.  If not, see <http://www.gnu.org/licenses/>.

classdef Movie < handle

    properties
        width           % width of each frame
        height          % height of each frame
        rate            % frame rate at which movie was capture

        nrFramesCaptured
        nrFramesTotal
        totalDuration
        skippedFrames

        nrVideoStreams  % number of video streams
        nrAudioStreams  % number of audio streams

        curFrame

        % options set at construction time
        imageType
        makeGrey
        gamma
        scaleFactor
    end

    methods

        function m = Movie(filename, varargin)

            % set default options
            m.imageType = [];
            m.makeGrey = false;
            m.gamma = [];
            m.scaleFactor = [];
            time = [];      % time span

            options = varargin;
            k = 1;
            while k<=length(options),
                switch options{k},
                case 'double',
                    m.imageType = 'double';
                case 'float',
                    m.imageType = 'float';
                case 'uint8',
                    m.imageType = 'uint8';
                case {'grey','gray', 'mono'},
                    m.makeGrey = true;
                case 'gamma'
                    m.gamma = options{k+1}; k = k+1;
                case 'reduce',
                    m.scaleFactor = options{k+1}; k = k+1;
                case 'time',
                    time = options{k+1}; k = k+1;
                otherwise,
                    error( sprintf('unknown option: %s', options{k}) );
                end
                k = k + 1;
            end
    
            currentdir = pwd;
            if ~ispc
                cd(fileparts(mfilename('fullpath'))); % FFGrab searches for AVbin in the current directory
            end

            FFGrab('build',filename, '', 0, 1, 1);
            
            if ~isempty(time)
                if numel(time) ~= 2
                    error('time must be a vector of length 2: [startTime stopTime]');
                end
                FFGrab('setTime',time(1),time(2));
            end

            FFGrab('setMatlabCommand', '');

            try
                FFGrab('doCapture');
            catch
                err = lasterror;
                if (~strcmp(err.identifier,'processFrame:STOP'))
                    rethrow(err);
                end
            end

            [m.nrVideoStreams, m.nrAudioStreams] = FFGrab('getCaptureInfo');

            % loop through getting all of the video data from each stream
            for i=1:m.nrVideoStreams
                [m.width, m.height, m.rate, m.nrFramesCaptured, m.nrFramesTotal, m.totalDuration] = FFGrab('getVideoInfo',i-1);
                m.skippedFrames = [];
                fprintf('%d x %d @ %f, %d frames\n', m.width, m.height, m.rate, m.nrFramesTotal);

                m.curFrame = 0;
            end
        end

        % destructor
        function delete(m)
            FFGrab('cleanUp');
        end

        function close(m)
            FFGrab('cleanUp');
        end

        function [im, time] = grab(m)
            if m.curFrame > m.nrFramesTotal
                im = [];
                return;
            end

            % read next frame from the file
            [data, time] = FFGrab('getVideoFrame', 0, m.curFrame);
            m.curFrame = m.curFrame + 1;

            if (numel(data) > 3*m.width*m.height)
                warning('Movie: dimensions do not match data size. Got %d bytes for %d x %d', numel(data), m.width, m.height);
            end

            if any(size(data) == 0)
                warning('Movie: could not decode frame %d', m.curFrame);
            else
                % the data ordering is wrong for matlab images, so permute it
                data = permute(reshape(data, 3, m.width, m.height),[3 2 1]);
                im = data;
            end

            % apply options specified at construction time
            if m.scaleFactor > 1,
                im = im(1:m.scaleFactor:end, 1:m.scaleFactor:end, :);
            end
            if m.makeGrey & (ndims(im) == 3),
                im = imono(im);
            end
            if ~isempty(m.imageType)
                im = cast(im, m.imageType);
            end

            if ~isempty(m.gamma)
                im = igamma(im, m.gamma);
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

