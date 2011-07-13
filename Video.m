%VIDEO Class to read from local video camera
%
% A concrete subclass of ImageSource that acquires images from a local
% camera.
%
% Methods::
% grab    Aquire and return the next image
% size    Size of image
% close   Close the image source
% char    Convert the object parameters to human readable string
%
% See also ImageSource, Movie.


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

% mmread brings the whole movie into memory.  Not entirely sure what
% libavbin uses memory-wise, it takes a long time to "open" the file.

classdef Video < handle

    properties
        width
        height
        rate

        curFrame
    end

    methods

        function m = Video(camera)
        %Video.Video Video camera constructor
        %   
        % V = Video(CAMERA, OPTIONS) is a Video object that acquires
        % images from the specified local video camera.
        %
        % If CAMERA is '?' then a list of available cameras, and their
        % characteristics is displayed.
        %   
        % Options::
        % 'uint8'     Return image with uint8 pixels (default)
        % 'float'     Return image with float pixels
        % 'double'    Return image with double precision pixels
        % 'grey'      Return image is greyscale
        % 'gamma',G   Apply gamma correction with gamma=G
        % 'scale',S   Subsample the image by S in both directions.

            % invoke the superclass constructor and process common arguments
            m = m@ImageSource(varargin);

            m.curFrame = 0;
        end

        % destructor
        function delete(m)
        end

        function close(m)
        %Video.close Close the image source
        %
        % V.close() closes the connection to the camera.

        end

        function [im, time] = grab(m, opt)
        %Video.grab Acquire image from the camera
        %
        % IM = V.grab() acquires an image from the camera.
        %
        % Notes::
        % - the function will block until the next frame is acquired.
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
        %Video.char Convert camera object to string
        %
        % V.char() is a string representing the state of the camera object in 
        % human readable form.

            s = '';
            s = strvcat(s, sprintf('%d video streams', m.nrVideoStreams));
            s = strvcat(s, sprintf('  %d x %d @ %d fps', m.width, m.height, m.rate));
            s = strvcat(s, sprintf('  %d frames, %f sec', m.nrFramesTotal, m.totalDuration));
            s = strvcat(s, sprintf('%d audio streams', m.nrAudioStreams));
        end

    end
end

