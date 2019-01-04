% setup
% Author: Ali Karimi <ali.karimi@brain.mpg.de>

util.clearAll;
util.setColors;
outputDir=fullfile(util.dir.getFig2,'EFG');
util.mkdir(outputDir)
colorsDE={[0.2 0.2 0.2],[227/255 65/255 50/255],...
    [50/255 205/255 50/255],[50/255 50/255 205/255]}';
x_width=10;
y_width=7;
apTuft= apicalTuft.getObjects('inhibitoryAxon');
synRatio=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynRatio');
targetingCount=apicalTuft.applyMethod2ObjectArray(apTuft,'getSynCount');

util.compareTableArrays(targetingCount,synRatio);

% Get the inverse of (targeting+1) (seed is removed and we have zeros otherwise)
% as the weight
seededAlongWholeApical=false;
if seededAlongWholeApical
    weight(1,:)=cellfun(@(x) 1./(x.L2ApicalShaft+1),...
        targetingCount(1,:),'UniformOutput',false);
    weight(2,:)=cellfun(@(x) 1./(x.DeepApicalShaft+1),...
        targetingCount(2,:),'UniformOutput',false);
else
    weight=apicalTuft.applyMethod2ObjectArray(apTuft,...
        'getSeedTargetingNumber');
end
% convert to cell array before plotting
synRatio=synRatio.Variables;
weight=weight.Variables;
%% E unweighted
fh=figure;ax=gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(:,5),[],...
    [{l2color},{dlcolor}]);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'E_unweighted.svg');

%% E weighted
fh=figure;ax=gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(:,5),weight(:,5),...
    [{l2color},{dlcolor}]);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'E_weighted.svg');
%% F uweighted
fh=figure;ax=gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(1,1:4),[],...
    colorsDE);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'F_unweighted.svg');

%% F weighted
fh=figure;ax=gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(1,1:4),weight(1,1:4),...
    colorsDE);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'F_weighted.svg');
%% G unweighted
fh=figure;ax=gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(2,1:4),[],...
    colorsDE);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'G_unweighted.svg');
%% G weighted
fh=figure;ax=gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(2,1:4),weight(2,1:4),...
    colorsDE);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'G_weighted.svg');

%% statistical testing

% switch to a double array if it is a weight table
if istable(weight{1})
    weightDouble=cellfun(@(table)table.weight,weight,...
        'UniformOutput',false);
end

weightDouble=[weightDouble{1,5};weightDouble{2,5}];
TestResults=util.stat.bootStrapTest(synRatio{1,5},synRatio{2,5},false,weightDouble);
writetable(TestResults,fullfile(outputDir,...
    util.addDateToFileName('E_bootStrapTestResults.txt')));