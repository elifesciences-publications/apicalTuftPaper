function [apTuftObj] = removeGroupingBifurcation(apTuftObj)
% removeGroupingBifurcation have separate groups for spine neck and double
% spine innervation
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~iscell(apTuftObj)
    apTuftObj={apTuftObj};
end
for d=1:length(apTuftObj)
    apTuftObj{d}.synGroups=[];
    apTuftObj{d}.synLabel={'Shaft','Spine','SpineDouble','SpineNeck'};
end
end

