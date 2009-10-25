%IREAD	Load an image
%
%	im = iread
%	im = iread(directory, options)
%	im = iread([], options)
%
%	Presents a file selection GUI from which the user can pick a file.
%	Uses the same path as previous call.
%
%   im = iread(filename, options)
%
%   Load the specified file. If the path is relative look for it along the
%   Matlab search path.
%	Wildcards are allowed in file names.  If multiple files match
%	a 3D image is returned where the last dimension is the number
%	of images contained.
%

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


function I = iread(filename, varargin)
	persistent path

    % options
    %
    %   'float
    %   'uint8
    %   'grey'
    %   'gray'
    %   'reduce', n

    opt.imageType = [];
    opt.scaleFactor = 1;
    opt.makeGrey = false;
    opt.debug = true;
    opt.gamma = [];

    options = varargin;
    k = 1;
    while k<=length(options),
        switch options{k},
        case 'double',
            opt.imageType = 'double';
        case 'float',
            opt.imageType = 'float';
        case 'uint8',
            opt.imageType = 'uint8';
        case {'grey','gray', 'mono'},
            opt.makeGrey = true;
        case 'gamma'
            opt.gamma = options{k+1}; k = k+1;
        case 'reduce',
            opt.scaleFactor = options{k+1}; k = k+1;
        otherwise,
            error( sprintf('unknown option: %s', options{k}) );
        end
        k = k + 1;
    end
    
	if nargin == 0,
		% invoke file browser GUI
        [file, npath] = uigetfile(...
            {'*.png;*.pgm;*.ppm;*.jpg;*.tif', 'All images';
            '*.pgm', 'PGM images';
            '*.jpg', 'JPEG images';
            '*.gif;*.png;*.jpg', 'web images';
            '*.*', 'All files';
            }, 'iread');
        if file == 0,
            fprintf('iread canceled from GUI\n');
            return;	% cancel button pushed
        else
            % save the path away for next time
            path = npath;
            im = loadimg([path '/' file], opt);
        end
    elseif (nargin == 1) & exist(filename,'dir'),
		% invoke file browser GUI
        if isempty(findstr(filename, '*')),
            filename = strcat(filename, '/*.*');
        end
        [file,npath] = uigetfile(filename, 'iread');
        if file == 0,
            fprintf('iread canceled from GUI\n');
            return;	% cancel button pushed
        else
            % save the path away for next time
            path = npath;
            im = loadimg([path pathsep file], opt);
        end
    else
        % some kind of filespec has been given
        if ~isempty(strfind(filename, '*')) | ~isempty(strfind(filename, '?')),
            % wild card files
            if opt.debug,
                fprintf('wildcard lookup\n');
            end
            s = dir(filename);		% do a wildcard lookup

            if length(s) == 0,
                error('no matching files found');
            end

            slashes = findstr(filename, '/');
            if isempty(slashes),
                fpath = './';
            else
                k = slashes(end);
                fpath = filename(1:k);
            end
            for i=1:length(s),
                im1 = loadimg([fpath s(i).name], opt);
                if ndims(im1) == 2,
                    im(:,:,i) = im1;
                elseif ndims(im1) == 3,
                    im(:,:,:,i) = im1;
                end
            end
        else
            % simple file, no wildcard
            if exist(filename)
                im = loadimg(filename, opt);
            else
                % see if it exists on the Matlab search path
                f = which(filename);
                if length(f) > 0
                    im = loadimg(f, opt);
                else
                    error('no such file');
                end
            end
        end
    end

    if nargout > 0,
        I = im;
    else
        if ndims(I) <= 3,
            idisp(I);
        end
    end
end

function im = loadimg(name, opt)
    if opt.debug,
        fprintf('loading %s\n', name);
    end
    im = imread(name);

    if opt.makeGrey & (ndims(im) == 3),
        im = imono(im);
    end
    if opt.scaleFactor > 1,
        im = im(1:scaleFactor:end, 1:scaleFactor:end, :);
    end
    if ~isempty(opt.imageType)
        if isempty(findstr(opt.imageType, 'int'))
            im = cast(im, opt.imageType) /255.0;
        else
            im = cast(im, opt.imageType);
        end
    end

    if ~isempty(opt.gamma)
        im = igamma(im, opt.gamma);
    end
end
