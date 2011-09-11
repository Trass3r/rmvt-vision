disp('- Machine Vision Toolbox for Matlab (release 3)')
tbpath = fileparts(which('blackbody'));
addpath( fullfile(tbpath, 'examples') );
addpath( fullfile(tbpath, 'images') );
% add the contrib code to the path
p = fullfile(tbpath, 'contrib/vgg');
if exist(p)
    addpath( p );
    disp([' - VGG contributed code (' p ')']);
end
p = fullfile(tbpath, 'contrib/EPnP/EPnP');
if exist(p)
    addpath( p );
    disp([' - EPnP contributed code (' p ')']);
end
p = fullfile(tbpath, ['contrib/vlfeat-0.9.9/toolbox/mex/' mexext]);
if exist(p)
    addpath( p );
    disp([' - VLFeat contributed code (' p ')']);
end
p = fullfile(tbpath, 'contrib/graphseg');
if exist(p)
    addpath( p );
    disp([' - graphseg contributed code (' p ')']);
end
