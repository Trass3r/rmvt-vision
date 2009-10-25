%IBLOBS	Compute blob features
%
%	F = iblobs(image)
%	F = iblobs(image, args)
%
%	Arguments are provided pairwise with a string followed by a value:
%
%		'aspect'	set pixel aspect ratio, default 1.0
%		'connect'	set connectivity, 4 (default) or 8
%		'greyscale'	compute greyscale moments 0 (default) or 1
%		'moments''	compute moments 0 (default)
%
%	and some arguments act as filters on the blob's whose features will
%	be returned:
%
%		'area', [min max] acceptable size range
%		'shape', [min max] acceptable shape range
%		'touch'		ignore blobs that touch the edge
%		'color', pix	accept only blobs of this pixel value
%
%	The return is a vector of structures with elements:
%
%		area	 is the number of pixels (for a binary image)
%		(x, y)   is the centroid with respect to top-left point which
%			 is (1,1)
%		(a, b)   are axis lengths of the "equivalent ellipse"
%		theta    the angle of the major ellipse axis to the 
%		         horizontal axis.
%		m00		zeroth moment
%		m01, m10	first order moments
%		m02, m11, m20	second order moments
%		shape	 shape factor, b/a
%		minx
%		maxx
%		miny
%		maxy
%		parent  parent blob (0 is edge)
%		color   color of this blob
%		label   label assigned to this blob
%
% SEE ALSO: ilabel imoments

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


function [F,labimg] = iblobs(im, varargin)
	
	[nr,nc] = size(im);


	i = 1;
	area_max = Inf;
	area_min = 0;
	shape_max = Inf;
	shape_min = 0;
	touch = NaN;
	aspect = 1.0;
	connect = 4;
    color_filter = NaN;
	greyscale_opt = false;
    moments_opt = false;
    boundary_opt = false;

	while i <= length(varargin),
		%disp(varargin{i})
		switch varargin{i},
		case 'area',	area_filt = varargin{i+1};
				area_max = area_filt(2);
				area_min = area_filt(1);
				i = i+1;
		case 'shape',	shape_filt = varargin{i+1};
				shape_max = shape_filt(2);
				shape_min = shape_filt(1);
				i = i+1;
		case 'color', 	color_filter = varargin{i+1}; i = i+1;
		case 'touch', 	touch = varargin{i+1}; i = i+1;
		case 'aspect', 	aspect = varargin{i+1}; i = i+1;
		case 'connect',	connect = varargin{i+1}; i = i+1;
		case 'greyscale',	greyscale_opt = varargin{i+1}; i = i+1;
		case 'moments',	moments_opt = varargin{i+1}; i = i+1;
		case 'boundary',	boundary_opt = true;
		end
		i = i+ 1;
	end

    % HACK ilabel should take int image
	[li,nl,parent,color,edge] = ilabel(im, connect);

	count = 0;
	for i=1:nl,
		binimage = (li == i);

		% determine the blob extent and touch status
		[y,x] = find(binimage);

		minx = min(x); maxx = max(x);
		miny = min(y); maxy = max(y);
		t = (parent(i) == 0);

		if greyscale_opt,
			% compute greyscale moments
			mf = imoments(binimage .* im);
		else
			mf = imoments(binimage);
		end
		if mf.a == 0,
			shape = NaN;
		else
			shape = mf.b / mf.a;
		end

		% apply various filters
		if 	((t == touch) || isnan(touch)) && ...
            ((color(i) == color_filter) || isnan(color_filter)) && ...
			(mf.area >= area_min) && ...
			(mf.area <= area_max) && ...
			(					...
				isnan(shape) ||			...
				(	~isnan(shape) &&		...
					(shape >= shape_min) &&	...
					(shape <= shape_max)	...
				)				...
			),

			ff = mf;
            [y,x] = ind2sub(size(im), edge(i));
            ff.edgepoint = [x y];    % a point on the perimeter

            if boundary_opt
                ff.edge = edgelist(im, [x y]);
                ff.perimeter = numrows(ff.edge);
                ff.circularity = 4*pi*ff.area/ff.perimeter^2;
            end

			ff.minx = minx;
			ff.maxx = maxx;
			ff.miny = miny;
			ff.maxy = maxy;
			ff.touch = t;
			ff.shape = shape;
            ff.label = i;
            ff.parent = parent(i);
            ff.color = color(i);
			count = count+1;
			Feature(count) = ff;
		end
	end

    % add children property
    for i=1:length(Feature)
        parent = f.parent;
        for f2=Feature
            if f2.label == parent
                f2.children = [f2.children i];
            end
        end
    end
	%fprintf('%d blobs in image, %d after filtering\n', nl, count);
    if nargout > 0
        if count > 0
            F = Feature;
        else
            F = [];
        end
    end
    if nargout > 1
        labimg = li;
    end
