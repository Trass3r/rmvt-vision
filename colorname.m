%COLORNAME Map between color names and RGB values
%
% rgb = colorname(name)
%
% name = colorname(rgb)
%
% Returns the name of the color that is closest (Euclidean) to the given RGB
% vector.
%
% Based on the standard X11 color database rgb.txt
function r = colorname(a, opt)

    if nargin < 2
        opt = '';
    end

    persistent  rgbtable;
    
    % ensure that the database is loaded
    if isempty(rgbtable),
        % load mapping table from file
        fprintf('loading rgb.txt\n');
        f = fopen('private/rgb.txt', 'r');
        k = 0;
        rgb = [];
        names = {};
        xy = [];

        while ~feof(f),       
            line = fgets(f);
            if line(1) == '#',
                continue;
            end

            [A,count,errm,next] = sscanf(line, '%d %d %d');
            if count == 3,
                k = k + 1;
                rgb(k,:) = A' / 255.0;
                names{k} = lower( strtrim(line(next:end)) );
                xy = xyz2xy( colorspace('RGB->XYZ', rgb) );
            end
        end
        s.rgb = rgb;
        s.names = names;
        s.xy = xy;
        rgbtable = s;
    end
    
    if isstr(a)
        % map name to rgb
        if a(1)  == '?' 
            % just do a wildcard lookup
            r = namelookup(rgbtable, a(2:end));
        else
            r = name2rgb(rgbtable, a, opt);
        end
    elseif iscell(a)
        % map multiple names to rgb
        for name=a,
            r = [r; name2rgb(rgbtable, a, opt)];
        end
    else
        if numel(a) == 3
            r = rgb2name(rgbtable, a(:)');
        elseif numcols(a) == 2 && strcmp(opt, 'xy')
            % convert xy to a name
            r = {};
            for k=1:numrows(a),
                r{k} = xy2name(rgbtable, a(k,:));
            end
        elseif numcols(a) == 3 && ~strcmp(opt, 'xy')
            % convert RGB data to a name
            r = {};
            for k=1:numrows(a),
                r{k} = rgb2name(rgbtable, a(k,:));
            end
        end
    end
end
    
function r = namelookup(table, s)
    s = lower(s);   % all matching done in lower case
    
    r = {};
    count = 1;
    for k=1:length(table.names),
        if ~isempty( findstr(table.names{k}, s) )
            r{count} = table.names{k};
            count = count + 1;
        end
    end
end

function r = name2rgb(table, s, opt)
    s = lower(s);   % all matching done in lower case
    
    for k=1:length(table.names),
        if strcmp(s, table.names(k)),
            r = table.rgb(k,:);
            if strcmp(opt, 'xy')
                r
                XYZ = colorspace('RGB->XYZ', r);
                XYZ
                r = xyz2xy(XYZ);
                r
            end
            return;
        end
    end
    r = [];
end

function r = rgb2name(table, v)
    d = table.rgb - ones(numrows(table.rgb),1) * v;
    n = colnorm(d');
    [z,k] = min(n);
    r = table.names{k};
end

function r = xy2name(table, v)
    d = table.xy - ones(numrows(table.xy),1) * v;
    n = colnorm(d');
    [z,k] = min(n);
    r = table.names{k};
end
