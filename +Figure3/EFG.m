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
synRatio=synRatio.Variables;


%% E 
fh=figure;ax=gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(:,5),[],...
    [{l2color},{dlcolor}]);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'E.svg');

%% F 
fh=figure;ax=gca;
%Plotting
hold on
util.plot.errorbarSpecificity(synRatio(1,1:4),[],...
    colorsDE);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'F.svg');
%% G 
fh=figure;ax=gca;
% Plotting
hold on
util.plot.errorbarSpecificity(synRatio(2,1:4),[],...
    colorsDE);
% Figure properties
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputDir,'G_unweighted.svg');

%% statistical testing
TestResults=util.stat.bootStrapTest(synRatio{1,5},synRatio{2,5},false);
writetable(TestResults,fullfile(outputDir,...
    util.addDateToFileName('E_bootStrapTestResults.txt')));
%% Manova test for the cortical area cortical areas