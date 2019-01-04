function [inhibitoryAxonDir] = getInhibitoryAxon()
%GETINHIBITORYAXON Get the directory of inhibitory axons

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

inhibitoryAxonDir=fullfile(util.dir.getAnnotation,'inihibitoryAxon');

end

