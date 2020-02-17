% Author: Ali Karimi <ali.karimi@brain.mpg.de>
% Get the mean +- SEM density of synapses
util.clearAll
apTuft=apicalTuft.getObjects('bifurcation');
synapseDen=apicalTuft. ...
    applyMethod2ObjectArray(apTuft,'getSynDensityPerType');
funSEM=@(x) round(util.stat.sem(x{1}(:,2:3).Variables,[],1),3);
sems=rowfun(funSEM,synapseDen(:,5),'OutputVariableNames',...
    {'SEM_Shaft_Spine'});
meanFun=@(x) round(mean(x{1}(:,2:3).Variables,1),2);
means=rowfun(meanFun,synapseDen(:,5),'OutputVariableNames',...
    {'Mean_Shaft_Spine'});
disp(means)
disp(sems)
