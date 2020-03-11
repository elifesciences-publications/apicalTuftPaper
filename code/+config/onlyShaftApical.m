function [] = onlyShaftApical()
%ONLYSHAFTAPICAL property of inhibitory axons with all the spine synapses
% removed from the shaft group. This is used for downweighting the seed type

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

prop = config.inhibitoryAxons();
prop.synGroups = {{4,5,7,8,10,11}',{6,9,12}',{10,11}'}';

prop.synLabel = {'L2Apical','DeepApical','Shaft','SpineDouble',...
    'SpineSingle','Soma','AIS','Glia'}';
end

