% Fig. 2C: The prediction accuracy of the axon preference (shaft vs. spine
% preference) in axons seeded from shaft and spine of 

% Author: Ali Karimi <ali.karimi@brain.mpg.de>
outputFolder = fullfile(util.dir.getFig(2),'C');
axonSwitchFraction = dendrite.synIdentity.loadSwitchFraction;

%% Plot
c = util.plot.getColors();
colors = {{c.l2color,c.l3color,c.l5color,c.l5Acolor},...
    {c.l2color,c.dlcolor,c.l5Acolor}};
layers = {'L1','L2'};
target = {'Shaft','Spine'};
xlocation = [1,3;2,4];
accuracyTable = axonSwitchFraction;
fname = 'Prediction Accuracy';
fh = figure('Name',fname);ax = gca;
hold on
for l = 1:length(layers)
    for t =  1:length(target)
        curSwitchFactor = axonSwitchFraction.(layers{l}).(target{t});
        accuracyTable.(layers{l}).(target{t}) = 100*(1-curSwitchFactor);
        for c = 1:length(curSwitchFactor)
            curLoc = xlocation(l,t) ;
            curAccuracy = (1-curSwitchFactor(c))*100;
            scatter(curLoc,curAccuracy,20,colors{l}{c},'x');
        end
    end
end
xlim([0.5,4.5]); ylim([0,100])
xticks(1:4);xticklabels([]); yticks([0:50:100]);yticklabels([0:50:100]);
    util.plot.cosmeticsSave...
        (fh,ax,3.6,3.2,outputFolder,[fname,'.svg'],...
        'off','on');
%% save table
accuracyTable.L1{'layer5AApicalDendriteSeeded','Spine'} = nan;
accuracyTable.L2{'L5A', 'Spine'} = nan;
excelFileName = fullfile(util.dir.getExcelDir(2),'Fig2C.xlsx');
util.table.write(struct2table(accuracyTable,'AsArray',true), excelFileName);