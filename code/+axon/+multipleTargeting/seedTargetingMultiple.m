% Note: This is extracted from Figure2.EFG. Removed the weighting part
% Get the inverse of (targeting+1) (seed is removed and we have zeros otherwise)
% as the weight
util.clearAll;
util.setColors;
outputDir = fullfile(util.dir.getFig(2),'EFG');
util.mkdir(outputDir)
colorsDE = {[0.2 0.2 0.2],[227/255 65/255 50/255],...
    [50/255 205/255 50/255],[50/255 50/255 205/255]}';
x_width = 10;
y_width = 7;
apTuft= apicalTuft.getObjects('inhibitoryAxon');
synRatio = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
targetingCount = apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount');

util.compareTableArrays(targetingCount,synRatio);



weight(1,:) = cellfun(@(x) 1./(x{1}.L2ApicalShaft+1),...
    targetingCount(1,:).Variables,'UniformOutput',false);
weight(2,:) = cellfun(@(x) 1./(x.DeepApicalShaft+1),...
    targetingCount(2,:).Variables,'UniformOutput',false);
% convert to cell array before plotting
synRatio = synRatio.Variables;
weight = weight.Variables;

%% E weighted
fh = figure;ax = gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(:,5),weight(:,5),...
    [{l2color},{dlcolor}]);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'E_weighted.svg');
%% F weighted
fh = figure;ax = gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(1,1:4),weight(1,1:4),...
    colorsDE);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'F_weighted.svg');

%% G weighted
fh = figure;ax = gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(2,1:4),weight(2,1:4),...
    colorsDE);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'G_weighted.svg');


%% Bootstrap test
% switch to a double array if it is a weight table
if istable(weight{1})
    weightDouble = cellfun(@(table)table.weight,weight,...
        'UniformOutput',false);
end
weightDouble = [weightDouble{1,5};weightDouble{2,5}];
TestResults = util.stat.bootStrapTest(synRatio{1,5},synRatio{2,5},false);
writetable(TestResults,fullfile(outputDir,...
    util.addDateToFileName('E_bootStrapTestResults.txt')));