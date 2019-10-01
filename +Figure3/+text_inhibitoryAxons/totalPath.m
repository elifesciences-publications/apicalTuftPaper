%% total pathdensity of axons: used in results text
% Author: Ali Karimi<ali.karimi@brain.mpg.de>
apTuft=apicalTuft.getObjects('inhibitoryAxon');
pathLength=apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getBackBonePathLength');
totalPatLength=rowfun(@(x) round(sum(x{1})./1000,1),pathLength(:,5));
disp(totalPatLength)
