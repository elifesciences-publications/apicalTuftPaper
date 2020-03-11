function [prop] = singleSpineLumped()
% singleSpineLumped Putting all the single spines into 1 Group for the 
% spine ratio mapping in inhibitory axons (seeded from shafts)

% Author: Ali Karimi <ali.karimi@brain.mpg.de>

prop = config.inhibitoryAxon();
prop.synGroups = {{1,4,5}',{2,7,8}',{6,9,12}',{10,11}'}';
% Note:  the order of spine double and single switches since the group with
% the smaller ID is the single spine (6) compared to double spines (10)
prop.synLabel = {'L2ApicalMinusSingleSpine','DeepApicalMinusSingleSpine',...
    'Shaft','SpineSinglePlusApicalSingle',...
    'SpineDouble','Soma','AIS','Glia'}';
end

