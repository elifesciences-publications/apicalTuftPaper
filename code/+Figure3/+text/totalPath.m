%% total pathdensity of axons: used in results text
% Author: Ali Karimi<ali.karimi@brain.mpg.de>
apTuft=apicalTuft.getObjects('inhibitoryAxon');
outputDir=fullfile(util.dir.getFig(3),'forText_inhibitoryAxon');

pathLength=apicalTuft.applyMethod2ObjectArray...
    (apTuft,'getBackBonePathLength');
totalPathLength =...
    rowfun(@(x) round(sum(x{1}.pathLengthInMicron,'all')./1000,2),...
    pathLength(:,5));

totalPathLength.Properties.VariableNames={'TotalPathLength'};
writetable(totalPathLength,fullfile(outputDir,'TotalPathLength.xlsx'));
;