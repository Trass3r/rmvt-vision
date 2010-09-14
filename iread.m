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


function [I,info] = iread(filename, varargin)
	persistent path

    % options
    %
    %   'float
    %   'uint8
    %   'grey'
    %   'gray'
    %   'grey_601'
    %   'grey_709'
    %   'grey_value'
    %   'gray_601'
    %   'gray_709'
    %   'gray_value'
    %   'reduce', n

    opt.type = {[], 'double', 'float', 'uint8'};
    opt.mkGrey = {[], 'grey', 'gray', 'mono', '601', 'gray_709', 'value'};
    opt.gamma = [];
    opt.reduce = 1;

    opt = tb_optparse(opt, varargin);

    im = [];
    
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
            filename = fullfile(path, file);
            im = loadimg(filename, opt);
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
            filename = fullfile(path, file);
            im = loadimg(filename, opt);
        end
    else
        % some kind of filespec has been given
        if ~isempty(strfind(filename, '*')) | ~isempty(strfind(filename, '?')),
            % wild card files, eg.  'seq/*.png', we need to look for a folder
            % seq somewhere along the path.
            if opt.verbose
                fprintf('wildcard lookup\n');
            end
            
            [pth,name,ext] = fileparts(filename);
            % search for the folder name along the path
            folderonpath = pth;
            for p=path2cell(userpath)'
                if exist( fullfile(p{1}, pth) ) == 7
                    folderonpath = fullfile(p{1}, pth);
                    break;
                end
            end
            s = dir( fullfile(folderonpath, [name, ext]));		% do a wildcard lookup

            if length(s) == 0,
                error('no matching files found');
            end

            for i=1:length(s),
                im1 = loadimg( fullfile(folderonpath, s(i).name), opt);
                if i==1
                    % preallocate storage, much quicker
                    im = zeros([size(im1) length(s)]);
                end
                if ndims(im1) == 2
                    im(:,:,i) = im1;
                elseif ndims(im1) == 3
                    im(:,:,:,i) = im1;
                end
            end
        else
            % simple file, no wildcard
            if strncmp(filename, 'http://', 7)
                im = loadimg(filename, opt);
            elseif exist(filename)
                im = loadimg(filename, opt);
            else
                % see if it exists on the Matlab search path
                for p=path2cell(userpath)'
                    if exist( fullfile(p{1}, filename) ) > 0
                        im = loadimg(fullfile(p{1}, filename), opt);
                        break;
                    end
                end
  
            end
        end
    end

                      
    if isempty(im)
        error(sprintf('cant open file: %s', filename));
    end
    if nargout > 0
        I = im;
        if nargout > 1
            info = imfinfo(filename);
        end
    else
        % if no output arguments display the image
        if ndims(I) <= 3
            idisp(I);
        end
    end
end

function im = loadimg(name, opt)

    % now we read the image
    im = imread(name);

    if opt.verbose
        if ndims(im) == 2
            fprintf('loaded %s, %dx%d\n', name, size(im,2), size(im,1));
        elseif ndims(im) == 3
            fprintf('loaded %s, %dx%dx%d\n', name, size(im,2), size(im,1), size(im,3));
        end
    end

    % optionally gamma correct it
    if ~isempty(opt.gamma)
        im = igamma(im, opt.gamma);
    end

    % optionally convert it to greyscale using specified method
    if ~isempty(opt.mkGrey) && (ndims(im) == 3)
        im = imono(im, opt.mkGrey);
    end

    % optionally decimate it
    if opt.reduce > 1,
        im = im(1:opt.reduce:end, 1:opt.reduce:end, :);
    end

    % optionally convert to specified numeric type
    if ~isempty(opt.type)
        if isempty(findstr(opt.type, 'int'))
            im = cast(im, opt.type) / double(intmax(class(im)));
        else
            im = cast(im, opt.type);
        end
    end
end
