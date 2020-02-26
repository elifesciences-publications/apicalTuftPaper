% Fig.1B is generated using Amira. We use the snippet below to get the 
% number of annotations in L2 and Deep used in Figure legends and methods

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

directory = dir(util.dir.getDensePlot);

fullname = @(file)fullfile(directory(file).folder,directory(file).name);
skel = cell(length(directory));
for file = 1:length(directory)
    if ~isempty(regexp(directory(file).name,'.nml', 'once'))
        skel{file} = ...
            skeleton(fullname(file));
        disp (['number of ',skel{file}.filename,' : ',...
            num2str(length(skel{file}.names))]);
    end
end
