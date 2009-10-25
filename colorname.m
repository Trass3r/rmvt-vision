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
function r = colorname(a)

    persistent  rgbtable;
    
    % ensure that the database is loaded
    if isempty(rgbtable),
        % load mapping table from file
        fprintf('loading rgb.txt\n');
        f = fopen('private/rgb.txt', 'r');
        k = 0;
        rgb = [];
        names = {};
        while ~feof(f),       
            line = fgets(f);
            if line(1) == '#',
                continue;
            end

            [A,count,errm,next] = sscanf(line, '%d %d %d');
            if count == 3,
                k = k + 1;
                rgb(k,:) = A';
                names{k} = lower( strtrim(line(next:end)) );
            end
        end
        s.rgb = rgb;
        s.names = names;
        rgbtable = s;
    end
    
    if isstr(a),
        % map name to rgb
        if a(1)  == '?' 
            % just do a wildcard lookup
            r = namelookup(rgbtable, a(2:end));
        else
            r = name2rgb(rgbtable, a) /255;
        end
    elseif iscell(a),
        % map multiple names to rgb
        for name=a,
            r = [r; nam2rgb(rgbtable, a)/255];
        end
    else
        if numel(a) == 3,
            r = rgb2name(rgbtable, 255*a(:)');
        else
            if numcols(a) ~= 3,
                error('must have 3 columns (RGB)');
            end
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
    
    function r = name2rgb(table, s)
        s = lower(s);   % all matching done in lower case
        
        for k=1:length(table.names),
            if strcmp(s, table.names(k)),
                r = table.rgb(k,:);
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
