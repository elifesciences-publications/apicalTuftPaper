function [apTuftObj] = groupInhibitorySpines(apTuftObj)
% groupInhibitorySpines create a separate group for spine neck and
% double innervation of head combined as InhSpines
% Author: Ali Karimi <ali.karimi@brain.mpg.de>
if ~iscell(apTuftObj)
    apTuftObj={apTuftObj};
end
for d=1:length(apTuftObj)
    apTuftObj{d}.synGroups={{3,4}'}';
    apTuftObj{d}.synLabel={'Shaft','Spine','InhSpines'};
end
end
